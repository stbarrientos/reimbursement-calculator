# Reimbursement Calculator

A simple reimbursement calculator algorithm.

### The Client Requests

SamCorp has requested some simple software to calculate reimbursement based on some simple rules.

#### Context:
- Each project has a start date and an end date.
- The first day of a project and the last day of a project are always "travel" days. Days in the middle of a project are "full" days.
- There are two types of cities a project can be in, high cost cities and low cost cities.

#### Project Sets:

Set 1:
- Project 1: Low Cost City Start Date: 9/1/15 End Date: 9/3/15

Set 2:
- Project 1: Low Cost City Start Date: 9/1/15 End Date: 9/1/15
- Project 2: High Cost City Start Date: 9/2/15 End Date: 9/6/15
- Project 3: Low Cost City Start Date: 9/6/15 End Date: 9/8/15

Set 3:
- Project 1: Low Cost City Start Date: 9/1/15 End Date: 9/3/15
- Project 2: High Cost City Start Date: 9/5/15 End Date: 9/7/15
- Project 3: High Cost City Start Date: 9/8/15 End Date: 9/8/15

Set 4:
- Project 1: Low Cost City Start Date: 9/1/15 End Date: 9/1/15
- Project 2: Low Cost City Start Date: 9/1/15 End Date: 9/1/15
- Project 3: High Cost City Start Date: 9/2/15 End Date: 9/2/15
- Project 4: High Cost City Start Date: 9/2/15 End Date: 9/3/15

### Assumptions I'm Making
- All dates provided are UTC, and will be formatted as <m/d/y>
- Projects will be given as JSON (see input.json for format)
