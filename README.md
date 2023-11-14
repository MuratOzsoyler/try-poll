# try-poll

Reproduce weird behavior of `FRP.Poll.step`

# Alternatives

The `Main` module contains two main implementations explained below.

# Working `main`

Commented out `main` is working. This is a test using `step` with `animate`.

# Flawed `main`

Current main is pushes matched `Route`s to an event which is used to create a `Poll`. But as you can observe in the console.

To reproduce the bug:

- `build` and `serve` the app.
- In the console see `routePoll: (Tuple Nothing Home)` message which is the initial value of the `Poll`.
- Click `Go to Settings` link.
- Observe that address bar changes and `routeEvent: (Tuple Nothing Settings)` written into the console
  whi̇ch means that the routing event is fired but `Poll` is not.
  Otherwise we should additionally see `routePoll: (Tuple Nothing Settings)` message in the console.
