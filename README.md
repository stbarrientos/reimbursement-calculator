# Reimbursement Calculator

A simple reimbursement calculator algorithm.

### Running the project
TL;DR
```
ruby main.rb
# or if you prefer docker
docker compose run release

# Output of executable:
Set 1 reimbursement: $145.00
Set 2 reimbursement: $570.00
Set 3 reimbursement: $465.00
Set 4 reimbursement: $205.00
```

This project can be run from any ruby 3.4.1 (untested in other versions) development environment. Simply run:
`ruby main.rb`
from the project root.

To run the project in a container (requires Docker) run:
`docker compose run release`

To run the project interatively if you don't have a local ruby development environment:
`docker compose run -it dev bash`

### Quick Directory Overview
The code lives primarily in `src`. All of the classes and logic live there.
You'll find `main.rb` in the root directory, this is "executable" for the project, and the only file meant to be called directly.
You can find the tests in the `tests` directory.
The `input.json` file is used by `main.rb` right now for the sake of simplicity. This file contains a sample input for the executable to operate on.

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
- Single day duration projects will use the travel day rate
- Overlapping project dates will use the more expensive rate of the overlapping projects.
- Projects that are date nieghbors (start / end within one day) will have the neighboring dates calculated as full days.

### Sample Calculations
In order to help clarify these rules and assumptions, here are the calculations for 2 examples.
Note: Each column is a date, numbered 1 .. final day in the set. The x's in each row correspond with the date that the project in that row is active.

```
Set 3 from input.json

          Dates
Project   1  2  3  4  5  6  7  8
Low Cost  x  x  x
High Cost             x  x  x
High Cost                      x
```

Date 1: The first date of the set, this is a Low Cost travel date.
Date 2: Day in the middle of a project, Low Cost full date.
Date 3: Last day of a project, Low Cost tavel date.
Date 4: No projects.
Date 5: First day of a project, High Cost travel date.
Date 6: Day in the middle of a project, High Cost full date.
Date 7: Last day of the project, however it neighbors the next project, therefore it is a High Cost full date.
Date 8: Even those this neighbors another project, it is the last date in the set, and is therefore a tavel date.

```
Set 4 from input.json

          Dates
Project   1  2  3
Low Cost  x
Low Cost  x
High Cost    x
High Cost    x  x
```

Date 1: Although this project both overlaps and is neighbors with sibling projects, it is the first date in the set, and therefore a travel day. We will use the Low Cost rate because it overlaps with another Low Cost project.
Date 2: Although this is the first date for project 3, it is both a neighbor and an overlapping date with projects 2 and 4. Project 4 is High Cost and overlapping, therefore we will use the High Cost full date rate.
Date 3: This is the last date in the set, so even though it is neighbors with project 3, it will be counted as a High Cost full day.