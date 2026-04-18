# O2C Configuration Steps - Detailed Guide

## 1. MASTER DATA SETUP

### Customer Master (XD01/XD02)
1. Navigate to: SAP Menu → Logistics → Sales and Distribution → Master Data → Business Partner
2. Click "Create" → Enter Customer Number (e.g., C001)
3. Set Organization Level:
   - Company Code (for FI integration)
   - Sales Organization (e.g., 1000 = Domestic)
   - Distribution Channel (e.g., 10 = Direct Sales)
4. Enter Customer Details:
   - Name, Address, Contact Info
   - Payment Terms (Net 30, 2/10 Net 30)
   - Incoterms (Delivery terms)
   - Default Currency
5. Credit Management Tab:
   - Assign Credit Group (e.g., "A" for high-value customers)
   - Credit Limit (e.g., $100,000)
   - Credit Representative
6. Shipping Data:
   - Shipping Conditions (Prepaid, Collect, etc.)
   - Delivery Priority
   - Route (shipping path)
7. Billing Data:
   - Billing Address
   - Invoice Consolidation (daily/weekly/monthly)
8. Save & confirm

### Product Master (MM01/MM02)
1. Navigate to: SAP Menu → Logistics → Materials Management → Master Data
2. Click "Create Material"
3. Set Material Type (FERT/HLFM/ROHM)
4. Basic Data: Description, UOM
5. Sales Organization Data
6. Batch Management configuration (if applicable)
7. Variant Configuration (if customizable)
8. Save & Activate

## 2. PRICING CONFIGURATION
- Define condition types (GROSS, DISCNT, SURCHARGE)
- Configure access sequences
- Create price records with tiered discounts
- Set up surcharges (freight, handling)

## 3. CREDIT MANAGEMENT
- Assign credit groups to customers
- Define credit limits
- Configure blocking rules & dunning procedures
- Set up credit hold approval workflow

## 4. BATCH MANAGEMENT
- Enable batch management in product master
- Configure batch determination strategy (FIFO/FEFO)
- Set up expiry date validation
- Enable serial number tracking

## 5. VARIANT CONFIGURATION
- Create configurable materials
- Define characteristics (Color, Size, Material)
- Build BOMs for variant combinations
- Configure variant pricing

## 6. REBATE PROCESSING
- Define rebate condition records
- Set up tiered rebate structure
- Configure accrual basis rules
- Establish claim processing workflow

Configuration complete! Ready for UAT and Go-Live.
