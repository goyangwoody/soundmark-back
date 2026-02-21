#!/usr/bin/env python3
"""
CI/CD용 OpenAPI 스키마 생성 및 검증 스크립트
"""
import sys
import json
from pathlib import Path
from generate_openapi import generate_openapi_schema


def validate_schema():
    """Validate OpenAPI schema"""
    schema_file = Path("openapi/openapi.json")
    
    if not schema_file.exists():
        print("❌ OpenAPI schema file not found. Generating...")
        generate_openapi_schema()
        return False
    
    with open(schema_file, "r", encoding="utf-8") as f:
        schema = json.load(f)
    
    # Basic validation
    required_keys = ["openapi", "info", "paths"]
    for key in required_keys:
        if key not in schema:
            print(f"❌ Missing required key: {key}")
            return False
    
    # Check API version
    if schema.get("openapi", "").startswith("3."):
        print(f"✅ Valid OpenAPI {schema['openapi']} schema")
    else:
        print(f"⚠️  Unexpected OpenAPI version: {schema.get('openapi')}")
    
    # Count endpoints
    num_paths = len(schema.get("paths", {}))
    num_schemas = len(schema.get("components", {}).get("schemas", {}))
    
    print(f"✅ Schema validation passed")
    print(f"   - Paths: {num_paths}")
    print(f"   - Schemas: {num_schemas}")
    
    return True


def main():
    """Main entry point"""
    print("🔍 Validating OpenAPI schema...\n")
    
    try:
        # Generate schema
        print("📦 Generating OpenAPI schema...\n")
        generate_openapi_schema()
        
        print("\n" + "="*60)
        print("🔍 Validating schema...\n")
        
        # Validate
        if validate_schema():
            print("\n✅ All checks passed!")
            return 0
        else:
            print("\n❌ Validation failed!")
            return 1
            
    except Exception as e:
        print(f"\n❌ Error: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
