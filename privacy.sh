#!/bin/sh

# Disable telemetry loggers for software in https://gitlab.com/dnsmichi/dotfiles

# GitHub CLI since 2.91.0 https://github.com/cli/cli/releases/tag/v2.91.0 
gh config set telemetry disabled
echo "Disabled telemetry in GitHub CLI"
