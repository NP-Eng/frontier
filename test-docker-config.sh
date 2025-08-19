#!/bin/bash

echo "Testing Docker Configuration for Frontier"
echo "========================================"

# Check if required files exist
echo "1. Checking required files..."
required_files=("Dockerfile" "Dockerfile.dev" "docker-compose.yml" "docker-compose.dev.yml" ".dockerignore")
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
        exit 1
    fi
done

# Check if template/node directory exists
echo -e "\n2. Checking template/node directory..."
if [ -d "template/node" ]; then
    echo "✅ template/node directory exists"
else
    echo "❌ template/node directory missing"
    exit 1
fi

# Check if Cargo.toml exists in template/node
echo -e "\n3. Checking template/node/Cargo.toml..."
if [ -f "template/node/Cargo.toml" ]; then
    echo "✅ template/node/Cargo.toml exists"
    # Check if the binary name is correct
    if grep -q "name = \"frontier-template-node\"" template/node/Cargo.toml; then
        echo "✅ Binary name 'frontier-template-node' found in Cargo.toml"
    else
        echo "❌ Binary name 'frontier-template-node' not found in Cargo.toml"
        exit 1
    fi
else
    echo "❌ template/node/Cargo.toml missing"
    exit 1
fi

# Check if main.rs exists
echo -e "\n4. Checking main.rs..."
if [ -f "template/node/src/main.rs" ]; then
    echo "✅ template/node/src/main.rs exists"
else
    echo "❌ template/node/src/main.rs missing"
    exit 1
fi

# Validate YAML syntax
echo -e "\n5. Validating YAML syntax..."
if command -v python3 &> /dev/null; then
    if python3 -c "import yaml; yaml.safe_load(open('docker-compose.yml'))" 2>/dev/null; then
        echo "✅ docker-compose.yml is valid YAML"
    else
        echo "❌ docker-compose.yml has invalid YAML syntax"
        exit 1
    fi
    
    if python3 -c "import yaml; yaml.safe_load(open('docker-compose.dev.yml'))" 2>/dev/null; then
        echo "✅ docker-compose.dev.yml is valid YAML"
    else
        echo "❌ docker-compose.dev.yml has invalid YAML syntax"
        exit 1
    fi
else
    echo "⚠️  Python3 not available, skipping YAML validation"
fi

# Check Dockerfile syntax (basic checks)
echo -e "\n6. Checking Dockerfile syntax..."
if grep -q "FROM rust:1.75-slim" Dockerfile; then
    echo "✅ Dockerfile has correct base image"
else
    echo "❌ Dockerfile missing correct base image"
    exit 1
fi

if grep -q "WORKDIR /app" Dockerfile; then
    echo "✅ Dockerfile has correct WORKDIR"
else
    echo "❌ Dockerfile missing correct WORKDIR"
    exit 1
fi

if grep -q "template/node" Dockerfile; then
    echo "✅ Dockerfile references template/node path"
else
    echo "❌ Dockerfile missing template/node path reference"
    exit 1
fi

# Check development Dockerfile
echo -e "\n7. Checking development Dockerfile..."
if grep -q "FROM rust:1.75-slim" Dockerfile.dev; then
    echo "✅ Dockerfile.dev has correct base image"
else
    echo "❌ Dockerfile.dev missing correct base image"
    exit 1
fi

if grep -q "USER substrate" Dockerfile.dev; then
    echo "✅ Dockerfile.dev has non-root user setup"
else
    echo "❌ Dockerfile.dev missing non-root user setup"
    exit 1
fi

echo -e "\n🎉 All Docker configuration tests passed!"
echo "The Docker setup should work correctly when Docker is available." 