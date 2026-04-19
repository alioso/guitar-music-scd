# Effect modules are loaded dynamically by run.py.
# Each effect must define:
#
#   MEDIA = {'still', 'video'}   # which media types it accepts (either or both)
#
#   def setup(frame, osc_state):
#       """Called once when the effect activates. Use for expensive precomputation.
#       frame     — first frame (uint8 BGR), do not modify in place
#       osc_state — dict with current OSC values (e.g. osc_state['amp'])
#       Returns a state dict passed to every render() call."""
#       return {}
#
#   def render(frame, osc_state, state):
#       """Called every frame. Must return a uint8 BGR image.
#       frame     — current raw frame (uint8 BGR), do not modify in place
#       osc_state — live OSC values updated each frame
#       state     — dict returned by setup()"""
#       return frame
