# Use the official ARC runner image as a base
# Find the latest appropriate tag from https://github.com/actions/runner/pkgs/container/actions-runner
FROM ghcr.io/actions/actions-runner:2.323.0

USER root

# Install Buildah and its dependencies
# Using apt-get for Debian/Ubuntu base. Adjust if using a different base.
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        buildah \
    && \
    # Clean up package lists
    rm -rf /var/lib/apt/lists/*

# Optional: If you experienced the registries.conf error even with sudo before,
# ensure the package installation correctly creates /etc/containers/registries.conf.
# You might add a check here during build `RUN test -f /etc/containers/registries.conf`

USER runner # Switch back to the non-root runner user