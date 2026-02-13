{ lib, pkgs, ... }:
let
  k9sSrc = pkgs.fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    rev = "master";
    sha256 = "sha256-PYaVzUAQuy5LBkyJ3otWX1iRYWSkt4sD3HIvpGTOiQY="; # replace after first build
  };
in
{
  home.packages = with pkgs; [
    kubectl
    yq
    kubectx
    kustomize
    stern
    kube-score
    kubectl-tree
    telepresence2
    cilium-cli
    tektoncd-cli
    cmctl # Manage cert-manager Certificate resources via cmctl
  ];

  home.file.".config/k9s/skins" = {
    source = "${k9sSrc}/skins";
    recursive = true;
  };
  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        ui = {
          skin = "transparent";
        };
      };
    };
    plugins = {
      # --- Certificate Management ---
      cert-status = {
        shortCut = "Shift-S";
        confirm = false;
        description = "Certificate status";
        scopes = [ "certificates" ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "cmctl status certificate --context $CONTEXT -n $NAMESPACE $NAME |& less"
        ];
      };

      cert-renew = {
        shortCut = "Shift-R";
        confirm = false;
        description = "Certificate renew";
        scopes = [ "certificates" ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "cmctl renew --context $CONTEXT -n $NAMESPACE $NAME |& less"
        ];
      };

      secret-inspect = {
        shortCut = "Shift-I";
        confirm = false;
        description = "Inspect secret";
        scopes = [ "secrets" ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "cmctl inspect secret --context $CONTEXT -n $NAMESPACE $NAME |& less"
        ];
      };

      # --- Debugging ---
      debug = {
        shortCut = "Shift-D";
        description = "Add debug container";
        dangerous = true;
        scopes = [ "containers" ];
        command = "bash";
        background = false;
        confirm = true;
        args = [
          "-c"
          "kubectl debug -it --context $CONTEXT -n=$NAMESPACE $POD --target=$NAME --image=nicolaka/netshoot:v0.14 --profile=sysadmin --share-processes -- zsh"
        ];
      };

      dive = {
        shortCut = "d";
        confirm = false;
        description = "Dive image";
        scopes = [ "containers" ];
        command = "dive";
        background = false;
        args = [ "$COL-IMAGE" ];
      };

      # --- Utilities ---
      kubectl-get-cmd = {
        shortCut = "Shift-B";
        confirm = false;
        description = "get into shell";
        scopes = [ "all" ];
        command = "bash";
        background = false;
        args = [
          "-c"
          ''
            (printf "copy/paste in a shell:\n\n"; if [ "$NAMESPACE" != "" -a  "$NAMESPACE" != "-"  ]; then printf "kubectl get  --context $CONTEXT -n $NAMESPACE $RESOURCE_NAME $NAME \n" ; else printf "kubectl get  --context $CONTEXT $RESOURCE_NAME $NAME \n"; fi ) |& less
          ''
        ];
      };

      stern = {
        shortCut = "Ctrl-Y";
        confirm = false;
        description = "Logs <Stern>";
        scopes = [ "pods" ];
        command = "stern";
        background = false;
        args = [
          "--tail"
          "50"
          "$FILTER"
          "-n"
          "$NAMESPACE"
          "--context"
          "$CONTEXT"
        ];
      };

      # --- Complex Scripts ---
      pvc-shell = {
        shortCut = "s";
        description = "Spawn an Ubuntu shell pod with this PVC mounted";
        scopes = [ "pvc" ];
        command = "sh";
        background = false;
        args = [
          "-c"
          # Note: escaping ''${NAME} prevents Nix from interpolating it
          ''
            echo "Starting a shell pod with PVC $NAME mounted at /mnt/data"
            cat <<EOF | kubectl --kubeconfig $KUBECONFIG apply -f > /dev/null 2>&1 -
            apiVersion: v1
            kind: Pod
            metadata:
              name: pvc-shell
              namespace: $NAMESPACE
            spec:
              restartPolicy: Never
              containers:
                - name: shell
                  image: ubuntu:latest
                  command: ["bash"]
                  stdin: true
                  tty: true
                  volumeMounts:
                    - name: vol
                      mountPath: /mnt/data
              volumes:
                - name: vol
                  persistentVolumeClaim:
                    claimName: $NAME
            EOF
            echo "Waiting for pod to be ready..."
            kubectl --kubeconfig $KUBECONFIG -n $NAMESPACE wait --for=condition=Ready pod/pvc-shell > /dev/null 2>&1
            kubectl --kubeconfig $KUBECONFIG -n $NAMESPACE exec -it pvc-shell -- bash
            kubectl --kubeconfig $KUBECONFIG -n $NAMESPACE delete pod pvc-shell --grace-period=0 --force=true > /dev/null 2>&1
          ''
        ];
      };

      trace-dns = {
        shortCut = "Shift-D";
        description = "Trace DNS requests";
        scopes = [
          "containers"
          "pods"
          "nodes"
        ];
        command = "bash";
        confirm = false;
        background = false;
        args = [
          "-c"
          # Note: We use ''${VAR} to escape bash variables inside Nix strings
          ''
            IG_VERSION=v0.34.0
            IG_IMAGE=ghcr.io/inspektor-gadget/ig:$IG_VERSION
            IG_FIELD=k8s.podName,src,dst,qr,qtype,name,rcode,latency_ns

            GREEN='\033[0;32m'
            RED='\033[0;31m'
            BLUE='\033[0;34m'
            NC='\033[0m' # No Color

            # Ensure kubectl version is 1.30 or later
            KUBECTL_VERSION=$(kubectl version --client | awk '/Client Version:/{print $3}')
            if [[ "$(echo "$KUBECTL_VERSION" | cut -d. -f2)" -lt 30 ]]; then
              echo -e "''${RED}kubectl version 1.30 or later is required''${NC}"
              sleep 3
              exit
            fi

            clear

            # Handle containers
            if [[ -n "$POD" ]]; then
              echo -e "''${GREEN}Tracing DNS requests for container ''${BLUE}''${NAME}''${GREEN} in pod ''${BLUE}''${POD}''${GREEN} in namespace ''${BLUE}''${NAMESPACE}''${NC}"
              IG_NODE=$(kubectl get pod "$POD" -n "$NAMESPACE" -o jsonpath='{.spec.nodeName}')
              kubectl debug --kubeconfig=$KUBECONFIG  --context=$CONTEXT -q \
                --profile=sysadmin "node/$IG_NODE" -it --image="$IG_IMAGE" -- \
                ig run trace_dns:$IG_VERSION -F "k8s.podName==$POD" -F "k8s.containerName=$NAME" \
                --fields "$IG_FIELD"
              exit
            fi

            # Handle pods
            if [[ -n "$NAMESPACE" ]]; then
              echo -e "''${GREEN}Tracing DNS requests for pod ''${BLUE}''${NAME}''${GREEN} in namespace ''${BLUE}''${NAMESPACE}''${NC}"
              IG_NODE=$(kubectl get pod "$NAME" -n "$NAMESPACE" -o jsonpath='{.spec.nodeName}')
              kubectl debug --kubeconfig=$KUBECONFIG  --context=$CONTEXT -q \
                --profile=sysadmin  -it --image="$IG_IMAGE" "node/$IG_NODE" -- \
                ig run trace_dns:$IG_VERSION -F "k8s.podName==$NAME" \
                --fields "$IG_FIELD"
              exit
            fi

            # Handle nodes
            echo -e "''${GREEN}Tracing DNS requests for node ''${BLUE}''${NAME}''${NC}"
            kubectl debug --kubeconfig=$KUBECONFIG  --context=$CONTEXT -q \
              --profile=sysadmin -it --image="$IG_IMAGE" "node/$NAME" -- \
              ig run trace_dns:$IG_VERSION --fields "$IG_FIELD"
          ''
        ];
      };
    };
  };

  home.sessionVariables = {
    KUBECOLOR_PRESET = "dark";
  };
  programs.kubecolor = {
    enable = true;
    enableAlias = true;
    enableZshIntegration = true;
    settings = {
      kubectl = lib.getExe pkgs.kubectl;
      preset = "dark";
    };
  };

  programs.kubeswitch = {
    enable = true;
    enableZshIntegration = true;
  };
}
