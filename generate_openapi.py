"""
OpenAPI Schema Generator for Soundmark API
프론트엔드(Kotlin Android)와 연동을 위한 OpenAPI 스키마 추출
"""
import json
from pathlib import Path
from app.main import app


def generate_openapi_schema():
    """Generate OpenAPI schema JSON file"""
    
    # Get OpenAPI schema from FastAPI app
    openapi_schema = app.openapi()
    
    # Create openapi directory if not exists
    openapi_dir = Path("openapi")
    openapi_dir.mkdir(exist_ok=True)
    
    # Save as JSON
    output_file = openapi_dir / "openapi.json"
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(openapi_schema, f, indent=2, ensure_ascii=False)
    
    print(f"✅ OpenAPI schema generated: {output_file}")
    print(f"   - API Version: {openapi_schema['info']['version']}")
    print(f"   - Endpoints: {len(openapi_schema['paths'])} paths")
    
    # Generate OpenAPI YAML (optional)
    try:
        import yaml
        yaml_file = openapi_dir / "openapi.yaml"
        with open(yaml_file, "w", encoding="utf-8") as f:
            yaml.dump(openapi_schema, f, allow_unicode=True, default_flow_style=False)
        print(f"✅ OpenAPI YAML generated: {yaml_file}")
    except ImportError:
        print("⚠️  PyYAML not installed. Skipping YAML generation.")
        print("   Install with: pip install pyyaml")
    
    # Print summary
    print("\n📋 API Endpoints Summary:")
    for path, methods in openapi_schema['paths'].items():
        for method in methods.keys():
            if method not in ['parameters']:
                tags = methods[method].get('tags', ['Untagged'])
                summary = methods[method].get('summary', 'No summary')
                print(f"   {method.upper():7} {path:40} [{', '.join(tags)}]")
    
    print("\n🔗 Usage:")
    print("   - Swagger UI: http://localhost:8000/docs")
    print("   - ReDoc: http://localhost:8000/redoc")
    print("   - OpenAPI JSON: http://localhost:8000/openapi.json")
    print(f"   - Local file: {output_file.absolute()}")
    
    return output_file


if __name__ == "__main__":
    generate_openapi_schema()
