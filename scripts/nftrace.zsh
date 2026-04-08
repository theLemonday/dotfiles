#!/usr/bin/env zsh

HOOK="$1"

# Shift the arguments so $@ contains only the nftables expression
shift 1
EXPRESSION="$@"

# Error Checking
if [[ -z "$HOOK" ]]; then
    echo "Usage: $0 <hook> [expression]"
    echo "Example: $0 prerouting ip protocol tcp"
    exit 1
fi

# Define Terminal Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ---------------------------------------------------------
# 1. THE DEAD MAN'S SWITCH (Bereinigung)
# ---------------------------------------------------------
cleanup() {
    echo -e "\n${YELLOW}Cancellation signal caught! Tearing down the trace...${NC}"
    # Suppress errors just in case the table is already gone
    sudo nft delete table inet nftrace_table 2>/dev/null
    echo -e "${GREEN}Cleanup complete. Your ruleset is untouched.${NC}"
    exit 0
}

# Trap SIGINT (Ctrl+C), SIGTERM (Kill), and EXIT, routing them to the cleanup function
trap cleanup SIGINT SIGTERM EXIT

# ---------------------------------------------------------
# 2. SETUP THE TRACE (Hinzufügen)
# ---------------------------------------------------------
echo -e "${GREEN}Deploying temporary trace on '$HOOK'...${NC}"
sudo nft add table inet nftrace_table
sudo nft "add chain inet nftrace_table nftrace_chain { type filter hook $HOOK priority raw ; }"

if [[ -n "$EXPRESSION" ]]; then
    sudo nft add rule inet nftrace_table nftrace_chain $EXPRESSION meta nftrace set 1
else
    sudo nft add rule inet nftrace_table nftrace_chain meta nftrace set 1
fi

echo -e "${GREEN}Monitoring traffic... (Press Ctrl+C to stop and auto-clean)${NC}"
echo "----------------------------------------------------------------------"

# ---------------------------------------------------------
# 3. THE PRISM (Farbliche Hervorhebung)
# ---------------------------------------------------------
# We pipe the output into awk to inject ANSI color codes in real-time
sudo nft monitor trace | awk '
{
    # Paint the word "trace" in Cyan
    gsub(/^trace/, "\033[36mtrace\033[0m")
    
    # Paint the hook name in Magenta
    gsub(/'"$HOOK"'/, "\033[35m'"$HOOK"'\033[0m")
    
    # Paint "verdict continue" in Blue
    gsub(/verdict continue/, "\033[34mverdict continue\033[0m")
    
    # Paint "policy accept" in Green
    gsub(/policy accept/, "\033[32mpolicy accept\033[0m")
    
    # Paint "drop" in bold Red
    gsub(/drop/, "\033[1;31mdrop\033[0m")
    
    # Paint IPv4 addresses in Yellow (using a basic regex)
    gsub(/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/, "\033[33m&\033[0m")
    
    # Paint MAC addresses in Gray
    gsub(/([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}/, "\033[90m&\033[0m")

    # Print the newly painted line
    print
}'
# #!/usr/bin/env zsh
#
# # Die Hilfefunktion (The Helper)
# show_help() {
#     echo "Usage: $0 [action] [hook] [expression...]"
#     echo ""
#     echo "Actions:"
#     echo "  add      Deploy the trace. Requires a hook and an optional expression."
#     echo "  list     (Default) Show the active trace setup."
#     echo "  remove   Tear down the trace table."
#     echo "  monitor  Run 'sudo nft monitor trace' to watch traffic."
#     echo "  help     Show this help message."
#     echo ""
#     echo "Hooks: prerouting, input, forward, output, postrouting"
#     echo ""
#     echo "Examples (The aojea Philosophy):"
#     echo "  $0 add prerouting ip protocol tcp      # Trace TCP traffic"
#     echo "  $0 add input tcp dport 22              # Trace SSH traffic"
#     echo "  $0 add forward                         # Trace ALL forwarded traffic"
#     echo "  $0 list                                # View current rules"
#     echo "  $0 remove                              # Clean up"
# }
#
# # Das Standardverhalten (Default Action)
# # ${1:-list} means: Use $1, but if it is empty, use "list"
# ACTION="${1:-list}"
#
# # An array of valid hooks for strict error checking
# VALID_HOOKS=(prerouting input forward output postrouting)
#
# case "$ACTION" in
#     add)
#         HOOK="$2"
#
#         # Fehlerbehandlung (Error Checking 1): Was a hook provided?
#         if [[ -z "$HOOK" ]]; then
#             echo "Error: Missing hook."
#             show_help
#             exit 1
#         fi
#
#         # Fehlerbehandlung (Error Checking 2): Is the hook valid?
#         # This is an advanced Zsh trick to check if an item exists in an array
#         if (( ! ${VALID_HOOKS[(I)$HOOK]} )); then
#             echo "Error: Invalid hook '$HOOK'."
#             echo "Must be one of: ${VALID_HOOKS[*]}"
#             exit 1
#         fi
#
#         # We shift the positional parameters by 2 to remove $1 (action) and $2 (hook).
#         # Everything left in $@ is now the native nftables expression.
#         shift 2
#         EXPRESSION="$@"
#
#         echo "Building the temporary trace table..."
#         sudo nft add table inet nftrace_table
#
#         echo "Deploying the trace chain to the '$HOOK' hook..."
#         sudo nft "add chain inet nftrace_table nftrace_chain { type filter hook $HOOK priority raw ; }"
#
#         # If an expression was provided, glue it to the trace command. 
#         # If it is empty, trace all traffic unconditionally.
#         if [[ -n "$EXPRESSION" ]]; then
#             echo "Adding trace rule for: $EXPRESSION"
#             sudo nft add rule inet nftrace_table nftrace_chain $EXPRESSION meta nftrace set 1
#         else
#             echo "No expression provided. Tracing ALL traffic on $HOOK..."
#             sudo nft add rule inet nftrace_table nftrace_chain meta nftrace set 1
#         fi
#
#         echo "--------------------------------------------------------"
#         echo "Success! Run '$0 monitor' to watch."
#         echo "--------------------------------------------------------"
#         ;;
#
#     list)
#         echo "Active trace ruleset:"
#         # The || operator prevents the script from throwing an ugly error if the table doesn't exist yet
#         sudo nft list table inet nftrace_table 2>/dev/null || echo "No traces currently active."
#         ;;
#
#     remove)
#         echo "Removing trace table..."
#         # Sending stderr to /dev/null hides the error if you try to remove it twice
#         sudo nft delete table inet nftrace_table 2>/dev/null && echo "Trace removed." || echo "No trace to remove."
#         ;;
#
#     monitor)
#         echo "Monitoring traces (Press Ctrl+C to stop)..."
#         sudo nft monitor trace
#         ;;
#
#     help|-h|--help)
#         show_help
#         ;;
#
#     *)
#         # Fehlerbehandlung (Error Checking 3): Did they type a bad action?
#         echo "Error: Unknown action '$ACTION'."
#         show_help
#         exit 1
#         ;;
# esac
