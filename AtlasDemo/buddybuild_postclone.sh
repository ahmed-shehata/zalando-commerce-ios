#!/bin/sh

sed -i ''  's#NSProcessInfo.*"USE_MOCK_API".*#true#' AtlasDemo/AppSetup.swift
