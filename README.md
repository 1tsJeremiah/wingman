# Wingman

Wingman is a collection of DevOps utilities and scripts used to automate server management tasks.  The repository contains shell scripts, Docker configurations and a small Python test suite.  The project also ships a minimal Node.js environment used mainly for linting and other helper scripts.

## Setup

### Python
1. Create a virtual environment and activate it.
2. Install dependencies (only `pytest` is required at the moment):
   ```bash
   pip install -U pytest
   ```

### Node.js
1. Navigate to the `node` directory.
2. Install packages using `npm`:
   ```bash
   cd node
   npm install
   ```

## Running Tests

Run the Python tests from the repository root with:
```bash
pytest
```

The Node.js workspace has a placeholder `npm test` script:
```bash
cd node
npm test
```

## Documentation

Additional information, including portal links, can be found in [docs/index.md](docs/index.md).
