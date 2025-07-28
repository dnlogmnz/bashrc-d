#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/docker-build.sh
# Build Scripts for Different Environments
# ==========================================================================================

# ------------------------------- Development Build ------------------------------ #
build_development() {
    echo "Building for Development..."
    
    # Using Docker Compose for development
    docker-compose -f docker-compose.dev.yml build
    
    # Or using direct docker build
    # docker build --target development -t fastapi-app:dev .
    
    echo "Development build completed successfully"
    echo "Run with: docker-compose -f docker-compose.dev.yml up"
}


# ------------------------------- Production Build ------------------------------ #
build_production() {
    echo "Building for Production..."
    
    # Check if secrets are available
    if [ -z "$DB_PASSWORD" ] || [ -z "$DB_USER" ]; then
        echo "WARNING: Some environment variables are not set."
        echo "Production build will use runtime environment variables."
    fi
    
    # Build with secrets (if available)
    if [ -n "$DB_PASSWORD" ]; then
        echo "Building with build-time secrets..."
        docker buildx build \
            --target production \
            --secret id=DB_PASSWORD,env=DB_PASSWORD \
            --secret id=DB_USER,env=DB_USER \
            --secret id=DB_NAME,env=DB_NAME \
            --secret id=DB_HOST,env=DB_HOST \
            --secret id=ACCESS_TOKEN_SECRET_KEY,env=ACCESS_TOKEN_SECRET_KEY \
            -t fastapi-app:prod .
    else
        echo "Building for runtime environment variables..."
        docker build --target production -t fastapi-app:prod .
    fi
    
    echo "Production build completed successfully"
}


# ------------------------------- Podman Development ------------------------------ #
build_podman_dev() {
    echo "Building with Podman for Development..."
    
    podman build --target development -t fastapi-app:dev .
    
    echo "Podman development build completed successfully"
    echo "Run with: podman run -p 8080:8080 -e DB_USER=devuser -e DB_PASSWORD=devpass fastapi-app:dev"
}


# ------------------------------- Testing Build ------------------------------ #
build_testing() {
    echo "Building for Testing Environment..."
    
    # Use production target but with test configuration
    docker build \
        --target production \
        --build-arg BUILD_MODE=production \
        -t fastapi-app:test .
    
    echo "Testing build completed successfully"
}


# ------------------------------- Staging Build ------------------------------ #
build_staging() {
    echo "Building for Staging Environment..."
    
    # Build with staging secrets from environment or CI/CD
    docker buildx build \
        --target production \
        --secret id=DB_PASSWORD,env=STAGING_DB_PASSWORD \
        --secret id=DB_USER,env=STAGING_DB_USER \
        --secret id=DB_NAME,env=STAGING_DB_NAME \
        --secret id=DB_HOST,env=STAGING_DB_HOST \
        --secret id=ACCESS_TOKEN_SECRET_KEY,env=STAGING_ACCESS_TOKEN_SECRET_KEY \
        -t fastapi-app:staging .
    
    echo "Staging build completed successfully"
}


# ------------------------------- Help Function ------------------------------ #
show_help() {
    echo "FastAPI Build Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  dev        Build for development (with hot reload)"
    echo "  prod       Build for production (optimized)"
    echo "  test       Build for testing environment"
    echo "  staging    Build for staging environment"
    echo "  podman     Build with Podman for development"
    echo "  help       Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 dev                    # Development build"
    echo "  $0 prod                   # Production build"
    echo "  DB_PASSWORD=xxx $0 prod   # Production with secrets"
}


# ------------------------------- Main Script ------------------------------ #
case "${1:-help}" in
    "dev"|"development")
        build_development
        ;;
    "prod"|"production")
        build_production
        ;;
    "test"|"testing")
        build_testing
        ;;
    "staging")
        build_staging
        ;;
    "podman")
        build_podman_dev
        ;;
    "help"|*)
        show_help
        ;;
esac


#-------------------------------------------------------------------------------------------
#--- Final do script 'docker-build.sh'
#-------------------------------------------------------------------------------------------