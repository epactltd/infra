# Architecture Diagrams

This directory contains tools and outputs for generating professional AWS architecture diagrams.

## Quick Start

### Generate Diagram with AWS Icons (Recommended)

```bash
# Install the diagrams library
pip install diagrams

# Generate PNG with official AWS icons
python generate_aws_diagram.py

# Output: multi_tenant_infrastructure.png
```

The generated PNG will have official AWS service icons and can be used in:
- Technical documentation
- Presentations
- Architecture review documents
- Customer-facing materials

## Files

- `generate_aws_diagram.py` - Python script using the diagrams library to create AWS icon-based architecture diagrams
- `multi_tenant_infrastructure.png` - Generated output (created after running the script)
- `README.md` - This file

## Alternative Tools

### For Browser-Based Editing (No Installation)
Use [diagrams.net (draw.io)](https://app.diagrams.net/):
1. Go to https://app.diagrams.net/
2. File → New → Blank Diagram
3. Click "More Shapes" button
4. Enable "AWS19" or "AWS 2021" shape libraries
5. Drag and drop AWS service icons
6. Export as PNG/SVG/PDF

### For Professional 3D Renders
Use [Cloudcraft](https://cloudcraft.co/):
- Import live AWS infrastructure
- Generate 3D isometric views
- Export high-resolution images
- Paid service ($49/month)

## Updating the Diagram

When infrastructure changes:
1. Update `generate_aws_diagram.py` with new services/connections
2. Run `python generate_aws_diagram.py`
3. Commit the new PNG to version control
4. Update `../infrastructure.md` if needed

## Diagram Best Practices

- **Use official AWS icons**: Helps with recognition and professionalism
- **Group by VPC/Region**: Show clear security boundaries
- **Color code by function**: Security (red), Compute (blue), Storage (green), etc.
- **Show data flow direction**: Use arrows to indicate traffic patterns
- **Label connections**: Add protocols, ports, or action descriptions
- **Keep it updated**: Regenerate after infrastructure changes
- **Version control**: Commit diagram source code alongside PNG outputs

## Dependencies

```bash
pip install diagrams
```

The `diagrams` library automatically downloads official AWS icons on first run.

