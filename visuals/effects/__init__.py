# Effect modules are loaded dynamically by run.py.
#
# ── Required ──────────────────────────────────────────────────────────────────
#
#   MEDIA = {'still', 'video'}   # which media types this effect accepts
#
#   def setup(frame, osc_state):
#       """Called once per activation. Use for expensive precomputation
#       (model loading, face detection, palette extraction, etc.).
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
#
# ── Optional ──────────────────────────────────────────────────────────────────
#
#   TYPE = 'process'   # (default) image processing effect — fx_*, tf_*, tp_*
#   TYPE = 'layout'    # screen composition effect — comp_* only
#
#   PERF = 'heavy'     # declare this if render() runs ML inference (DNN, YOLO,
#                      # any neural net) every frame. The scheduler guarantees
#                      # that no two heavy effects share the same activation chain,
#                      # preventing frame-rate collapse. Omit for pure math effects.
#
#   def setup(frame, osc_state, context=None):
#       # Declare context if you need to pick a second media item (comp_* effects).
#       # context['media']        — full list of (path, type) tuples
#       # context['current_path'] — the main media item already picked
#       # context['screen']       — (SW, SH) output resolution
#       ...
#
#   def teardown(state):
#       # Define if you opened resources (e.g. VideoCapture) that need closing.
#       ...
#
# ── Naming convention ─────────────────────────────────────────────────────────
#
#   fx_   general image effect, no detection  (fx_grain, fx_vignette)
#   tf_   target face                         (tf_blur_face, tf_block_face)
#   tp_   target person                       (tp_bw, tp_ghost)
#   to_   target object via YOLO class        (to_highlight_car)
#   comp_ screen composition / layout         (comp_dual, comp_super)
#   col_  colour treatment                    (col_tint, col_invert)
#   mot_  motion, video-only                  (mot_slow, mot_freeze)
#
# ── Performance rule ──────────────────────────────────────────────────────────
#
#   If your render() calls a neural network (OpenCV DNN, YOLO, MediaPipe, etc.)
#   you MUST set PERF = 'heavy'. This is enforced by convention, not by code.
#   Heavy effects cost 40–80ms/frame; two in the same chain would drop to ~8fps.
#   Pure NumPy/OpenCV math effects (grain, blur, colour) cost 2–5ms and can
#   stack freely — do NOT set PERF = 'heavy' on them.
