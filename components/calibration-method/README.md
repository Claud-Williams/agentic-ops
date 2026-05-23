# calibration-method: Predicting Effort, Then Correcting the Prediction

Estimates are usually guesses that never get checked. This is a small habit that turns them into something that gets better over time.

## The problem

I kept under- and over-estimating how long tasks would take, and so did the agents working with me. The subtler problem: even when we "knew" a kind of task was faster than it felt, the estimate still came out wrong, because knowing a fact and applying it at the moment of estimating are different things.

## The approach

Log every estimate against its actual, group by task type, and read the resulting band back before making the next estimate of that type. Close the loop, so the system corrects itself instead of repeating the same bias.

## How it works

- When a task is estimated, a row is logged: the task, the predicted effort, and its type.
- On completion, the actual is filled in and the variance recorded.
- Over time each task type develops a band, for example "this kind of analytical write-up runs three to six times faster than it feels".
- Crucially, before any new estimate, the relevant band is read back and applied explicitly. The bias is corrected at the moment it would otherwise repeat.

## Key design decisions

- **The actual is the point.** An estimate log without actuals is a wish list. Filling in the actual is what turns it into data.
- **Group by type.** Bands only mean something within a kind of task; mixing types washes the signal out.
- **Close the loop at the decision point.** The insight that mattered: a known bias does not fix itself. The band has to be consulted at the moment of estimating, or the estimate drifts straight back to gut feel.

## A small example

See [examples/estimate-log.md](examples/estimate-log.md).

## What I learned

The interesting failure was not bad estimates, it was that knowing the correction did not make it fire. Building the read-back step into the moment of estimating, rather than trusting myself to remember, is what actually moved the numbers.
