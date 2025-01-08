# Reimbursement Calculator

A simple reimbursement calculator algorithm.

### Running the project
This project can be run from any ruby 3.4.1 development environment. Simply run:
`ruby main.rb`
from the project root.

If you don't have a local ruby development environment, you can run the project interactively via:
`docker compose run -it dev bash`

To run the project non-interactively (if you just want to see the final results) run:
`docker compose run release`

### The Client Requests

SamCorp has requested some simple software to calculate reimbursement based on some simple rules.

#### Context:
- Each project has a start date and an end date.
- The first day of a project and the last day of a project are always "travel" days. Days in the middle of a project are "full" days.
- There are two types of cities a project can be in, high cost cities and low cost cities.

#### Rules:
- First day and last day of a project, or sequence of projects, is a travel day.
- Any day in the middle of a project, or sequence of projects, is considered a full day.
- If there is a gap between projects, then the days on either side of that gap are travel days.
- If two projects push up against each other, or overlap, then those days are full days as well.
- Any given day is only ever counted once, even if two projects are on the same day.
- A travel day is reimbursed at a rate of 45 dollars per day in a low cost city.
- A travel day is reimbursed at a rate of 55 dollars per day in a high cost city.
- A full day is reimbursed at a rate of 75 dollars per day in a low cost city.
- A full day is reimbursed at a rate of 85 dollars per day in a high cost city.

### Assumptions I'm Making
- All dates provided are UTC, and will be formatted as <m/d/y>
- Projects will be given as JSON (see input.json for format)
- All cities will be either "High Cost City" or "Low Cost City"
- When 2 projects in different city types occur on the same day, we will use the High Cost City rate
