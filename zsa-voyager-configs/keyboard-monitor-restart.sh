#!/bin/bash
systemctl --user daemon-reload
systemctl --user restart keyboard-watcher.service
