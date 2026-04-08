#!/usr/bin/env zsh

# Die Hilfefunktion (The Helper)
show_help() {
    echo "Usage: $0 [action] [hook] [expression...]"
    echo ""
    echo "Actions:"
    echo "  add      Deploy the trace. Requires a hook and an optional expression."
    echo "  list     (Default) Show the active trace setup."
    echo "  remove   Tear down the trace table."
    echo "  monitor  Run 'sudo nft monitor trace' to watch traffic."
    echo "  help     Show this help message."
    echo ""
    echo "Hooks: prerouting, input, forward, output, postrouting"
    echo ""
    echo "Examples (The aojea Philosophy):"
    echo "  $0 add prerouting ip protocol tcp      # Trace TCP traffic"
    echo "  $0 add input tcp dport 22              # Trace SSH traffic"
    echo "  $0 add forward                         # Trace ALL forwarded traffic"
    echo "  $0 list                                # View current rules"
    echo "  $0 remove                              # Clean up"
}

# Das Standardverhalten (Default Action)
# ${1:-list} means: Use $1, but if it is empty, use "list"
ACTION="${1:-list}"

# An array of valid hooks for strict error checking
VALID_HOOKS=(prerouting input forward output postrouting)

case "$ACTION" in
    add)
        HOOK="$2"
        
        # Fehlerbehandlung (Error Checking 1): Was a hook provided?
        if [[ -z "$HOOK" ]]; then
            echo "Error: Missing hook."
            show_help
            exit 1
        fi
        
        # Fehlerbehandlung (Error Checking 2): Is the hook valid?
        # This is an advanced Zsh trick to check if an item exists in an array
        if (( ! ${VALID_HOOKS[(I)$HOOK]} )); then
            echo "Error: Invalid hook '$HOOK'."
            echo "Must be one of: ${VALID_HOOKS[*]}"
            exit 1
        fi

        # We shift the positional parameters by 2 to remove $1 (action) and $2 (hook).
        # Everything left in $@ is now the native nftables expression.
        shift 2
        EXPRESSION="$@"

        echo "Building the temporary trace table..."
        sudo nft add table inet nftrace_table

        echo "Deploying the trace chain to the '$HOOK' hook..."
        sudo nft "add chain inet nftrace_table nftrace_chain { type filter hook $HOOK priority raw ; }"

        # If an expression was provided, glue it to the trace command. 
        # If it is empty, trace all traffic unconditionally.
        if [[ -n "$EXPRESSION" ]]; then
            echo "Adding trace rule for: $EXPRESSION"
            sudo nft add rule inet nftrace_table nftrace_chain $EXPRESSION meta nftrace set 1
        else
            echo "No expression provided. Tracing ALL traffic on $HOOK..."
            sudo nft add rule inet nftrace_table nftrace_chain meta nftrace set 1
        fi

        echo "--------------------------------------------------------"
        echo "Success! Run '$0 monitor' to watch."
        echo "--------------------------------------------------------"
        ;;
        
    list)
        echo "Active trace ruleset:"
        # The || operator prevents the script from throwing an ugly error if the table doesn't exist yet
        sudo nft list table inet nftrace_table 2>/dev/null || echo "No traces currently active."
        ;;
        
    remove)
        echo "Removing trace table..."
        # Sending stderr to /dev/null hides the error if you try to remove it twice
        sudo nft delete table inet nftrace_table 2>/dev/null && echo "Trace removed." || echo "No trace to remove."
        ;;
        
    monitor)
        echo "Monitoring traces (Press Ctrl+C to stop)..."
        sudo nft monitor trace
        ;;
        
    help|-h|--help)
        show_help
        ;;
        
    *)
        # Fehlerbehandlung (Error Checking 3): Did they type a bad action?
        echo "Error: Unknown action '$ACTION'."
        show_help
        exit 1
        ;;
esac
