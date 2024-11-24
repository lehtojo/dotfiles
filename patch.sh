#!/usr/bin/env nix-shell
#!nix-shell -p gcc patchelf -i bash

# Check if an executable is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-executable> <dependency-name-1> [dependency-name-2 ...]"
    exit 1
fi

EXECUTABLE="$1"
shift # Remove the executable from the arguments

# Verify the executable exists
if [ ! -f "$EXECUTABLE" ]; then
    echo "Error: $EXECUTABLE does not exist."
    exit 1
fi

# Ensure NIX_CC is set
if [ -z "$NIX_CC" ]; then
    echo "Error: NIX_CC is not defined. Ensure you are running this script inside a nix-shell."
    exit 1
fi

# Locate the dynamic interpreter
INTERPRETER_PATH=$(cat $NIX_CC/nix-support/dynamic-linker 2>/dev/null)
if [ -z "$INTERPRETER_PATH" ]; then
    echo "Error: Could not determine the dynamic linker path."
    exit 1
fi

# Patch the interpreter
echo "Patching interpreter to $INTERPRETER_PATH for $EXECUTABLE..."
if ! patchelf --set-interpreter "$INTERPRETER_PATH" "$EXECUTABLE"; then
    echo "Error: Failed to patch interpreter."
    exit 1
fi

# Initialize RPATH variable
RPATH=""

# Process each dependency
for DEPENDENCY in "$@"; do
    echo "Searching for $DEPENDENCY in the Nix store..."
    DEPENDENCY_PATH=$(find /nix/store -name "$DEPENDENCY" | head -n 1)

    if [ -z "$DEPENDENCY_PATH" ]; then
        echo "Error: $DEPENDENCY not found in the Nix store."
        exit 1
    fi

    DEPENDENCY_DIR=$(dirname "$DEPENDENCY_PATH")
    echo "Found $DEPENDENCY in $DEPENDENCY_DIR"
    
    # Append to RPATH
    if [ -z "$RPATH" ]; then
        RPATH="$DEPENDENCY_DIR"
    else
        RPATH="$RPATH:$DEPENDENCY_DIR"
    fi
done

# Patch the RPATH
echo "Patching RPATH to include $RPATH for $EXECUTABLE..."
if ! patchelf --set-rpath "$RPATH" "$EXECUTABLE"; then
    echo "Error: Failed to patch RPATH."
    exit 1
fi

echo "Patching completed successfully for $EXECUTABLE."

