# Future Value Calculation Stored Procedure

## Overview
This SQL stored procedure calculates the **Future Value (FV)** of a series of cash flows over specified time periods using a discount factor. It demonstrates the use of transactions, error handling, and temporary tables for financial computations.

---

## Features
- Calculates Future Value using the formula:
  \[
  FV = CF \times (1 + r)^t
  \]
  - **CF**: Cash Flow
  - **r**: Discount Rate
  - **t**: Time Period
- Handles input as comma-separated strings for flexibility.
- Ensures data integrity using transactions (`BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK`).
- Manages errors using `TRY...CATCH` blocks.

---

## How It Works
1. **Inputs:**
   - `@CashFlows`: Comma-separated cash flows (e.g., `100,200,300`).
   - `@Rate`: Annual discount rate as a decimal (e.g., `0.05` for 5%).
   - `@TimePeriods`: Comma-separated time periods (e.g., `1,2,3`).

2. **Processing:**
   - Splits inputs into temporary tables.
   - Iteratively computes the future value for each cash flow using the discount factor:
     \[
     FV = CF \times (1 + r)^t
     \]

3. **Output:**
   - Returns a table containing the **TimePeriod**, **CashFlow**, and **FutureValue**.

---

## Example Usage
### Input:
- `@CashFlows = '100,200,300'`
- `@Rate = 0.05`
- `@TimePeriods = '1,2,3'`

### Output:
| TimePeriod | CashFlow | FutureValue |
|------------|----------|-------------|
| 1          | 100      | 105.00      |
| 2          | 200      | 220.50      |
| 3          | 300      | 347.29      |

---

## Benefits
- Demonstrates SQL proficiency with:
  - Transaction management.
  - Error handling.
  - Iterative calculations.
- Optimized for readability and maintainability.



---

### **Link to the scripts**
If you'd like users to download the file, link to the raw version of the file:

```markdown
[Download the Future Value Calculation Script](https://github.com/Idris-lawal/Future-Value-cashflow-using-SQL/blob/main/CashflowFV%20scripts.sql)

