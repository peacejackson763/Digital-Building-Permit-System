# Digital Building Permit System

A comprehensive blockchain-based building permit management system built on Stacks using Clarity smart contracts.

## System Overview

This system manages the entire building permit lifecycle through five interconnected smart contracts:

1. **Application Processing Contract** (`application-processing.clar`)
    - Handles permit application submissions
    - Manages approval/rejection workflow
    - Tracks application status and history

2. **Inspector Scheduling Contract** (`inspector-scheduling.clar`)
    - Coordinates building inspection appointments
    - Manages inspector availability and assignments
    - Tracks inspection results and compliance

3. **Code Compliance Contract** (`code-compliance.clar`)
    - Enforces safety and zoning requirements
    - Validates construction specifications
    - Maintains compliance standards database

4. **Fee Calculation Contract** (`fee-calculation.clar`)
    - Calculates permit fees based on project scope
    - Handles payment processing and tracking
    - Manages fee structures and updates

5. **Completion Certification Contract** (`completion-certification.clar`)
    - Issues occupancy permits for finished buildings
    - Validates final inspections and compliance
    - Manages certificate lifecycle

## Key Features

- **Transparent Process**: All permit activities recorded on blockchain
- **Automated Workflows**: Smart contract automation reduces processing time
- **Compliance Tracking**: Real-time monitoring of code compliance
- **Fee Management**: Automated fee calculation and payment processing
- **Digital Certificates**: Blockchain-based occupancy permits

## Contract Architecture

### Data Types

- **Applications**: Permit requests with project details
- **Inspections**: Scheduled inspections with results
- **Compliance Records**: Safety and zoning validation data
- **Fee Structures**: Dynamic pricing based on project parameters
- **Certificates**: Digital occupancy permits

### Access Control

- **Applicants**: Submit applications and pay fees
- **Inspectors**: Schedule inspections and record results
- **Officials**: Approve/reject applications and issue certificates
- **Administrators**: Manage system parameters and fee structures

## Getting Started

### Prerequisites

- Clarinet CLI installed
- Node.js and npm for testing
- Stacks wallet for transactions

### Installation

1. Clone the repository
2. Install dependencies: `npm install`
3. Run tests: `npm test`
4. Deploy contracts: `clarinet deploy`

### Usage

1. **Submit Application**: Call `submit-application` with project details
2. **Pay Fees**: Use `calculate-and-pay-fees` to process payment
3. **Schedule Inspection**: Book inspection slots via `schedule-inspection`
4. **Track Progress**: Monitor application status through contract calls
5. **Receive Certificate**: Get occupancy permit after final approval

## Testing

The system includes comprehensive tests covering:
- Application submission and processing
- Inspector scheduling and management
- Code compliance validation
- Fee calculation accuracy
- Certificate issuance workflow

Run tests with: `npm test`

## Security Considerations

- Input validation on all contract functions
- Access control for sensitive operations
- Immutable audit trail of all activities
- Protection against common smart contract vulnerabilities

## Contributing

1. Fork the repository
2. Create feature branch
3. Add tests for new functionality
4. Submit pull request with detailed description

## License

MIT License - see LICENSE file for details
