{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 8,
      "minor": 6,
      "revision": 2,
      "architecture": "x64",
      "modernui": 1
    },
    "classnamespace": "box",
    "rect": [
      0,
      0,
      2400,
      1200
    ],
    "bglocked": 0,
    "openinpresentation": 0,
    "default_fontsize": 12.0,
    "default_fontface": 0,
    "default_fontname": "Arial",
    "gridonopen": 1,
    "gridsize": [
      15.0,
      15.0
    ],
    "gridsnaponopen": 1,
    "objectsnaponopen": 1,
    "statusbarvisible": 2,
    "toolbarvisible": 1,
    "lefttoolbarpinned": 0,
    "toptoolbarpinned": 0,
    "righttoolbarpinned": 0,
    "bottomtoolbarpinned": 0,
    "toolbars_unpinned_last_save": 0,
    "tallnewobj": 0,
    "boxanimatetime": 200,
    "enablehscroll": 1,
    "enablevscroll": 1,
    "devicewidth": 0.0,
    "description": "Chimera - ambient guitar piece with motive and ocean layers",
    "digest": "",
    "tags": "",
    "style": "",
    "subpatcher_template": "",
    "assistshowspatchername": 0,
    "boxes": [
      {
        "box": {
          "id": "lbl_s1",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            40,
            20,
            120,
            22
          ],
          "outlettype": [],
          "text": "=== INPUT ==="
        }
      },
      {
        "box": {
          "id": "adc",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            40,
            80,
            69,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "plugin~"
        }
      },
      {
        "box": {
          "id": "dry_gain",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            115,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.85"
        }
      },
      {
        "box": {
          "id": "lbl_dry",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            105,
            115,
            90,
            22
          ],
          "outlettype": [],
          "text": "dry (center)"
        }
      },
      {
        "box": {
          "id": "lbl_s2",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            280,
            20,
            240,
            22
          ],
          "outlettype": [],
          "text": "=== TIMER + ARC (720s = 12min) ==="
        }
      },
      {
        "box": {
          "id": "start_btn",
          "maxclass": "button",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            280,
            40,
            24,
            24
          ],
          "outlettype": [
            "bang"
          ],
          "parameter_enable": 0,
          "presentation": 1,
          "presentation_rect": [
            10,
            10,
            24,
            24
          ]
        }
      },
      {
        "box": {
          "id": "lbl_start",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            310,
            44,
            50,
            22
          ],
          "outlettype": [],
          "text": "START"
        }
      },
      {
        "box": {
          "id": "reset_btn",
          "maxclass": "button",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            360,
            40,
            24,
            24
          ],
          "outlettype": [
            "bang"
          ],
          "parameter_enable": 0,
          "presentation": 1,
          "presentation_rect": [
            50,
            10,
            24,
            24
          ]
        }
      },
      {
        "box": {
          "id": "lbl_reset",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            390,
            44,
            80,
            22
          ],
          "outlettype": [],
          "text": "RESET/STOP"
        }
      },
      {
        "box": {
          "id": "msg_start",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            75,
            21,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "1"
        }
      },
      {
        "box": {
          "id": "msg_stop",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            360,
            75,
            21,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "0"
        }
      },
      {
        "box": {
          "id": "metro",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            105,
            76,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "metro 50"
        }
      },
      {
        "box": {
          "id": "counter",
          "maxclass": "newobj",
          "numinlets": 5,
          "numoutlets": 4,
          "patching_rect": [
            280,
            135,
            69,
            22
          ],
          "outlettype": [
            "int",
            "",
            "",
            "int"
          ],
          "text": "counter"
        }
      },
      {
        "box": {
          "id": "ticks_ms",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            170,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "* 50"
        }
      },
      {
        "box": {
          "id": "ms_sec",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            200,
            69,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "/ 1000."
        }
      },
      {
        "box": {
          "id": "t_disp",
          "maxclass": "flonum",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            280,
            235,
            70,
            22
          ],
          "outlettype": [
            "",
            "bang"
          ],
          "format": 6,
          "parameter_enable": 0
        }
      },
      {
        "box": {
          "id": "lbl_sec",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            355,
            237,
            30,
            22
          ],
          "outlettype": [],
          "text": "sec"
        }
      },
      {
        "box": {
          "id": "t_min",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            400,
            235,
            55,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "/ 60."
        }
      },
      {
        "box": {
          "id": "min_disp",
          "maxclass": "flonum",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            400,
            265,
            60,
            22
          ],
          "outlettype": [
            "",
            "bang"
          ],
          "format": 6,
          "parameter_enable": 0
        }
      },
      {
        "box": {
          "id": "lbl_min",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            465,
            267,
            30,
            22
          ],
          "outlettype": [],
          "text": "min"
        }
      },
      {
        "box": {
          "id": "evo_div",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            300,
            62,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "/ 720."
        }
      },
      {
        "box": {
          "id": "evo_clip",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            280,
            330,
            90,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "clip 0. 1."
        }
      },
      {
        "box": {
          "id": "lbl_evo",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            360,
            332,
            110,
            22
          ],
          "outlettype": [],
          "text": "evolution 0..1"
        }
      },
      {
        "box": {
          "id": "cg_sub",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            440,
            300,
            62,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "- 540."
        }
      },
      {
        "box": {
          "id": "cg_sign",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            440,
            330,
            90,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "clip 0. 1."
        }
      },
      {
        "box": {
          "id": "lbl_cg",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            525,
            332,
            100,
            22
          ],
          "outlettype": [],
          "text": "capture gate"
        }
      },
      {
        "box": {
          "id": "onset_div",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            370,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "/ 3."
        }
      },
      {
        "box": {
          "id": "onset_clip",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            280,
            400,
            90,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "clip 0. 1."
        }
      },
      {
        "box": {
          "id": "lbl_onset",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            360,
            402,
            90,
            22
          ],
          "outlettype": [],
          "text": "onset 0..1"
        }
      },
      {
        "box": {
          "id": "lbl_s3",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            280,
            450,
            200,
            22
          ],
          "outlettype": [],
          "text": "=== SWELL DETECTION ==="
        }
      },
      {
        "box": {
          "id": "rms_fast",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            280,
            480,
            139,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "average~ 2205 rms"
        }
      },
      {
        "box": {
          "id": "lbl_rmsf",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            350,
            482,
            120,
            22
          ],
          "outlettype": [],
          "text": "fast RMS (~50ms)"
        }
      },
      {
        "box": {
          "id": "rms_slow_raw",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            280,
            515,
            146,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "average~ 44100 rms"
        }
      },
      {
        "box": {
          "id": "rms_slow_lp",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            545,
            90,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "lores~ 0.3"
        }
      },
      {
        "box": {
          "id": "lbl_rmss",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            350,
            547,
            120,
            22
          ],
          "outlettype": [],
          "text": "slow rms (1s+lp)"
        }
      },
      {
        "box": {
          "id": "rms_fast_sig2ctl",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            280,
            580,
            104,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "snapshot~ 10"
        }
      },
      {
        "box": {
          "id": "rms_slow_sig2ctl",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            390,
            580,
            104,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "snapshot~ 10"
        }
      },
      {
        "box": {
          "id": "swell_add_eps",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            615,
            69,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "+ 0.001"
        }
      },
      {
        "box": {
          "id": "swell_ratio",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            645,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "/ 1."
        }
      },
      {
        "box": {
          "id": "lbl_ratio",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            345,
            647,
            110,
            22
          ],
          "outlettype": [],
          "text": "slow/fast ratio"
        }
      },
      {
        "box": {
          "id": "tex_sub",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            680,
            55,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "- 0.4"
        }
      },
      {
        "box": {
          "id": "tex_div",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            710,
            55,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "/ 0.6"
        }
      },
      {
        "box": {
          "id": "tex_clip",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            280,
            740,
            90,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "clip 0. 1."
        }
      },
      {
        "box": {
          "id": "lbl_tex",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            360,
            742,
            200,
            22
          ],
          "outlettype": [],
          "text": "texture (0=angular 1=swell)"
        }
      },
      {
        "box": {
          "id": "tex_line",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            775,
            97,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "line 0. 200"
        }
      },
      {
        "box": {
          "id": "lbl_texl",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            360,
            777,
            120,
            22
          ],
          "outlettype": [],
          "text": "smoothed texture"
        }
      },
      {
        "box": {
          "id": "lbl_s4",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            560,
            20,
            200,
            22
          ],
          "outlettype": [],
          "text": "=== PITCH AUTO-TRACK ==="
        }
      },
      {
        "box": {
          "id": "yin",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            560,
            80,
            111,
            22
          ],
          "outlettype": [
            "signal",
            "float"
          ],
          "text": "yin~ 2048 0.9"
        }
      },
      {
        "box": {
          "id": "lbl_yin",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            670,
            82,
            190,
            22
          ],
          "outlettype": [],
          "text": "yin~ (pitch, confidence)"
        }
      },
      {
        "box": {
          "id": "conf_thresh",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            670,
            115,
            55,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 0.7"
        }
      },
      {
        "box": {
          "id": "conf_gate",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            560,
            150,
            62,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "gate 1"
        }
      },
      {
        "box": {
          "id": "lbl_cgate",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            625,
            152,
            120,
            22
          ],
          "outlettype": [],
          "text": "confidence gate"
        }
      },
      {
        "box": {
          "id": "cents_div",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            560,
            185,
            62,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "/ 100."
        }
      },
      {
        "box": {
          "id": "semi_int",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            560,
            215,
            41,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "int"
        }
      },
      {
        "box": {
          "id": "semi_change",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            560,
            245,
            62,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "change"
        }
      },
      {
        "box": {
          "id": "root_line",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            560,
            275,
            104,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "line 0. 5000"
        }
      },
      {
        "box": {
          "id": "lbl_rootline",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            640,
            277,
            170,
            22
          ],
          "outlettype": [],
          "text": "smoothed root (5s glide)"
        }
      },
      {
        "box": {
          "id": "root_disp",
          "maxclass": "flonum",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            560,
            310,
            70,
            22
          ],
          "outlettype": [
            "",
            "bang"
          ],
          "format": 6,
          "parameter_enable": 0
        }
      },
      {
        "box": {
          "id": "lbl_root",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            635,
            312,
            110,
            22
          ],
          "outlettype": [],
          "text": "current root st"
        }
      },
      {
        "box": {
          "id": "lbl_s5",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1750,
            20,
            220,
            22
          ],
          "outlettype": [],
          "text": "=== HARMONIC PRESETS (auto) ==="
        }
      },
      {
        "box": {
          "id": "preset_msg_0",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            60,
            150,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "preset 0 7 12 19"
        }
      },
      {
        "box": {
          "id": "preset_msg_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            85,
            150,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "preset 0 5 12 17"
        }
      },
      {
        "box": {
          "id": "preset_msg_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            110,
            150,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "preset 0 7 14 21"
        }
      },
      {
        "box": {
          "id": "preset_msg_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            135,
            150,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "preset 0 5 10 17"
        }
      },
      {
        "box": {
          "id": "pre1_cmp",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            165,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 270."
        }
      },
      {
        "box": {
          "id": "pre1_once",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            190,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "change"
        }
      },
      {
        "box": {
          "id": "pre2_cmp",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            225,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 510."
        }
      },
      {
        "box": {
          "id": "pre2_once",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            250,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "change"
        }
      },
      {
        "box": {
          "id": "lbl_pre1",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1830,
            192,
            110,
            22
          ],
          "outlettype": [],
          "text": "4:30 \u2192 quartal"
        }
      },
      {
        "box": {
          "id": "lbl_pre2",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1830,
            252,
            80,
            22
          ],
          "outlettype": [],
          "text": "8:30 \u2192 airy"
        }
      },
      {
        "box": {
          "id": "preset_route",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1750,
            285,
            104,
            22
          ],
          "outlettype": [
            "",
            ""
          ],
          "text": "route preset"
        }
      },
      {
        "box": {
          "id": "preset_unpack",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 4,
          "patching_rect": [
            1750,
            315,
            118,
            22
          ],
          "outlettype": [
            "",
            "",
            "",
            ""
          ],
          "text": "unpack 0 0 0 0"
        }
      },
      {
        "box": {
          "id": "poff_store_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            355,
            27,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "f"
        }
      },
      {
        "box": {
          "id": "poff_store_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            385,
            27,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "f"
        }
      },
      {
        "box": {
          "id": "poff_store_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            415,
            27,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "f"
        }
      },
      {
        "box": {
          "id": "poff_store_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            445,
            27,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "f"
        }
      },
      {
        "box": {
          "id": "lbl_s6",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            820,
            20,
            170,
            22
          ],
          "outlettype": [],
          "text": "=== MOTIVE TAPS ==="
        }
      },
      {
        "box": {
          "id": "tapin",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            820,
            70,
            104,
            22
          ],
          "outlettype": [
            "tapconnect"
          ],
          "text": "tapin~ 60000"
        }
      },
      {
        "box": {
          "id": "mot_onset_sig",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            970,
            70,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0."
        }
      },
      {
        "box": {
          "id": "mot_vol_line",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            970,
            100,
            111,
            22
          ],
          "outlettype": [
            "signal",
            "bang"
          ],
          "text": "line~ 0.7 500"
        }
      },
      {
        "box": {
          "id": "mot_vol_mult",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            970,
            130,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~"
        }
      },
      {
        "box": {
          "id": "lbl_mvol",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1035,
            132,
            110,
            22
          ],
          "outlettype": [],
          "text": "motive envelope"
        }
      },
      {
        "box": {
          "id": "tapout_0",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            820,
            140,
            118,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "tapout~ 7300.0"
        }
      },
      {
        "box": {
          "id": "tap_lp_0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            820,
            175,
            125,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "lores~ 3000 0.3"
        }
      },
      {
        "box": {
          "id": "tap_vol_0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            820,
            210,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.5"
        }
      },
      {
        "box": {
          "id": "tapout_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            910,
            140,
            125,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "tapout~ 19100.0"
        }
      },
      {
        "box": {
          "id": "tap_lp_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            910,
            175,
            125,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "lores~ 3000 0.3"
        }
      },
      {
        "box": {
          "id": "tap_vol_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            910,
            210,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.5"
        }
      },
      {
        "box": {
          "id": "tapout_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1000,
            140,
            125,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "tapout~ 41700.0"
        }
      },
      {
        "box": {
          "id": "tap_lp_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1000,
            175,
            125,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "lores~ 3000 0.3"
        }
      },
      {
        "box": {
          "id": "tap_vol_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1000,
            210,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.5"
        }
      },
      {
        "box": {
          "id": "lbl_s7",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1100,
            20,
            180,
            22
          ],
          "outlettype": [],
          "text": "=== OCEAN CAPTURE ==="
        }
      },
      {
        "box": {
          "id": "cap_tex_line",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1100,
            60,
            97,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "line 0. 200"
        }
      },
      {
        "box": {
          "id": "cap_gate_float",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1100,
            90,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "* 1."
        }
      },
      {
        "box": {
          "id": "cap_threshold",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1100,
            120,
            55,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 0.1"
        }
      },
      {
        "box": {
          "id": "lbl_capgate",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1160,
            122,
            170,
            22
          ],
          "outlettype": [],
          "text": "combined capture gate"
        }
      },
      {
        "box": {
          "id": "ocean_buf_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1100,
            160,
            160,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "buffer~ ocean1 20000"
        }
      },
      {
        "box": {
          "id": "ocean_rec_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1100,
            195,
            118,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "record~ ocean1"
        }
      },
      {
        "box": {
          "id": "ocean_buf_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            160,
            160,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "buffer~ ocean2 18000"
        }
      },
      {
        "box": {
          "id": "ocean_rec_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            195,
            118,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "record~ ocean2"
        }
      },
      {
        "box": {
          "id": "ocean_buf_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1280,
            160,
            160,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "buffer~ ocean3 22000"
        }
      },
      {
        "box": {
          "id": "ocean_rec_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1280,
            195,
            118,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "record~ ocean3"
        }
      },
      {
        "box": {
          "id": "ocean_buf_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1370,
            160,
            160,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "buffer~ ocean4 16000"
        }
      },
      {
        "box": {
          "id": "ocean_rec_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1370,
            195,
            118,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "record~ ocean4"
        }
      },
      {
        "box": {
          "id": "lbl_s8",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1400,
            20,
            180,
            22
          ],
          "outlettype": [],
          "text": "=== OCEAN PLAYBACK ==="
        }
      },
      {
        "box": {
          "id": "msg_od_ramp_start",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1200,
            80,
            95,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "0.7 300000"
        }
      },
      {
        "box": {
          "id": "od_ramp_up",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1320,
            80,
            118,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "line 0. 300000"
        }
      },
      {
        "box": {
          "id": "lbl_odramp",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1395,
            82,
            80,
            22
          ],
          "outlettype": [],
          "text": "ocean depth"
        }
      },
      {
        "box": {
          "id": "od_fade_cmp",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1320,
            115,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 630."
        }
      },
      {
        "box": {
          "id": "od_fade_once",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1320,
            145,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "change"
        }
      },
      {
        "box": {
          "id": "od_fade_msg",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1320,
            175,
            80,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "0. 90000"
        }
      },
      {
        "box": {
          "id": "od_ramp_down",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1320,
            205,
            118,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "line 0.7 90000"
        }
      },
      {
        "box": {
          "id": "ocean_depth_val",
          "maxclass": "flonum",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1320,
            240,
            60,
            22
          ],
          "outlettype": [
            "",
            "bang"
          ],
          "format": 6,
          "parameter_enable": 0
        }
      },
      {
        "box": {
          "id": "lbl_odval",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1385,
            242,
            140,
            22
          ],
          "outlettype": [],
          "text": "ocean depth 0..0.7"
        }
      },
      {
        "box": {
          "id": "lbl_oc_1",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1400,
            40,
            120,
            22
          ],
          "outlettype": [],
          "text": "--- Ocean G1 ---"
        }
      },
      {
        "box": {
          "id": "lfo_phasor_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            80,
            132,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "phasor~ 0.011111"
        }
      },
      {
        "box": {
          "id": "lfo_mul2_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            110,
            55,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 2."
        }
      },
      {
        "box": {
          "id": "lfo_sub1_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1458,
            110,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ -1."
        }
      },
      {
        "box": {
          "id": "lfo_abs_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1516,
            110,
            48,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "abs~"
        }
      },
      {
        "box": {
          "id": "lfo_neg_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1554,
            110,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ -1."
        }
      },
      {
        "box": {
          "id": "lfo_tri_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1612,
            110,
            55,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ 1."
        }
      },
      {
        "box": {
          "id": "lfo_depth_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1670,
            110,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.05"
        }
      },
      {
        "box": {
          "id": "lfo_base_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1738,
            110,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ 0.18"
        }
      },
      {
        "box": {
          "id": "groove_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1400,
            150,
            132,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ ocean1 0"
        }
      },
      {
        "box": {
          "id": "lbl_gr_1",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1465,
            152,
            50,
            22
          ],
          "outlettype": [],
          "text": "groove~"
        }
      },
      {
        "box": {
          "id": "rate_snap_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            185,
            104,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "snapshot~ 20"
        }
      },
      {
        "box": {
          "id": "rate_comp_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            215,
            286,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "expr -12. * log($f1 + 0.0001) / 0.6931"
        }
      },
      {
        "box": {
          "id": "ptch_add1_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            250,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "+ 0."
        }
      },
      {
        "box": {
          "id": "ptch_add2_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            280,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "+ 0."
        }
      },
      {
        "box": {
          "id": "ptch_sig_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            310,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0."
        }
      },
      {
        "box": {
          "id": "fs_h_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1400,
            385,
            60,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "hilbert~"
        }
      },
      {
        "box": {
          "id": "fs_ccos_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1480,
            385,
            50,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "cycle~"
        }
      },
      {
        "box": {
          "id": "fs_csin_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1480,
            415,
            50,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "cycle~"
        }
      },
      {
        "box": {
          "id": "fs_cphase_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1480,
            355,
            35,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "0.25"
        }
      },
      {
        "box": {
          "id": "fs_sig_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1545,
            385,
            60,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0.15"
        }
      },
      {
        "box": {
          "id": "fs_mr_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            450,
            35,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~"
        }
      },
      {
        "box": {
          "id": "fs_mi_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1450,
            450,
            35,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~"
        }
      },
      {
        "box": {
          "id": "fs_ni_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1450,
            480,
            55,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ -1."
        }
      },
      {
        "box": {
          "id": "fs_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1425,
            510,
            35,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "oc_env_cmp_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1490,
            80,
            55,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 0.0"
        }
      },
      {
        "box": {
          "id": "oc_env_once_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1490,
            110,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "change"
        }
      },
      {
        "box": {
          "id": "oc_entry_msg_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1490,
            140,
            70,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "1. 10000"
        }
      },
      {
        "box": {
          "id": "oc_env_line_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1490,
            175,
            111,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "line 0. 10000"
        }
      },
      {
        "box": {
          "id": "oc_fade_cmp_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1490,
            215,
            69,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 630.0"
        }
      },
      {
        "box": {
          "id": "oc_fade_once_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1490,
            245,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "change"
        }
      },
      {
        "box": {
          "id": "oc_fade_msg_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1490,
            275,
            70,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "0. 30000"
        }
      },
      {
        "box": {
          "id": "oc_vol_mult_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1490,
            310,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "* 0."
        }
      },
      {
        "box": {
          "id": "oc_vol_sig_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1490,
            340,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0."
        }
      },
      {
        "box": {
          "id": "oc_vol_mult2_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            425,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~"
        }
      },
      {
        "box": {
          "id": "oc_pan_L_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            550,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.9659"
        }
      },
      {
        "box": {
          "id": "oc_pan_R_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1485,
            550,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.2588"
        }
      },
      {
        "box": {
          "id": "lbl_oc_2",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1560,
            40,
            120,
            22
          ],
          "outlettype": [],
          "text": "--- Ocean G2 ---"
        }
      },
      {
        "box": {
          "id": "lfo_phasor_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            80,
            132,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "phasor~ 0.009091"
        }
      },
      {
        "box": {
          "id": "lfo_mul2_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            110,
            55,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 2."
        }
      },
      {
        "box": {
          "id": "lfo_sub1_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1618,
            110,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ -1."
        }
      },
      {
        "box": {
          "id": "lfo_abs_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1676,
            110,
            48,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "abs~"
        }
      },
      {
        "box": {
          "id": "lfo_neg_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1714,
            110,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ -1."
        }
      },
      {
        "box": {
          "id": "lfo_tri_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1772,
            110,
            55,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ 1."
        }
      },
      {
        "box": {
          "id": "lfo_depth_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1830,
            110,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.06"
        }
      },
      {
        "box": {
          "id": "lfo_base_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1898,
            110,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ 0.25"
        }
      },
      {
        "box": {
          "id": "groove_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1560,
            150,
            132,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ ocean2 0"
        }
      },
      {
        "box": {
          "id": "lbl_gr_2",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1625,
            152,
            50,
            22
          ],
          "outlettype": [],
          "text": "groove~"
        }
      },
      {
        "box": {
          "id": "rate_snap_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            185,
            104,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "snapshot~ 20"
        }
      },
      {
        "box": {
          "id": "rate_comp_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            215,
            286,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "expr -12. * log($f1 + 0.0001) / 0.6931"
        }
      },
      {
        "box": {
          "id": "ptch_add1_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            250,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "+ 0."
        }
      },
      {
        "box": {
          "id": "ptch_add2_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            280,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "+ 0."
        }
      },
      {
        "box": {
          "id": "ptch_sig_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            310,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0."
        }
      },
      {
        "box": {
          "id": "fs_h_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1560,
            385,
            60,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "hilbert~"
        }
      },
      {
        "box": {
          "id": "fs_ccos_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1640,
            385,
            50,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "cycle~"
        }
      },
      {
        "box": {
          "id": "fs_csin_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1640,
            415,
            50,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "cycle~"
        }
      },
      {
        "box": {
          "id": "fs_cphase_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1640,
            355,
            35,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "0.25"
        }
      },
      {
        "box": {
          "id": "fs_sig_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1705,
            385,
            60,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0.15"
        }
      },
      {
        "box": {
          "id": "fs_mr_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            450,
            35,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~"
        }
      },
      {
        "box": {
          "id": "fs_mi_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1610,
            450,
            35,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~"
        }
      },
      {
        "box": {
          "id": "fs_ni_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1610,
            480,
            55,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ -1."
        }
      },
      {
        "box": {
          "id": "fs_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1585,
            510,
            35,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "oc_env_cmp_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1650,
            80,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 45.0"
        }
      },
      {
        "box": {
          "id": "oc_env_once_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1650,
            110,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "change"
        }
      },
      {
        "box": {
          "id": "oc_entry_msg_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1650,
            140,
            70,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "1. 10000"
        }
      },
      {
        "box": {
          "id": "oc_env_line_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1650,
            175,
            111,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "line 0. 10000"
        }
      },
      {
        "box": {
          "id": "oc_fade_cmp_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1650,
            215,
            69,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 645.0"
        }
      },
      {
        "box": {
          "id": "oc_fade_once_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1650,
            245,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "change"
        }
      },
      {
        "box": {
          "id": "oc_fade_msg_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1650,
            275,
            70,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "0. 30000"
        }
      },
      {
        "box": {
          "id": "oc_vol_mult_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1650,
            310,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "* 0."
        }
      },
      {
        "box": {
          "id": "oc_vol_sig_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1650,
            340,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0."
        }
      },
      {
        "box": {
          "id": "oc_vol_mult2_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            425,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~"
        }
      },
      {
        "box": {
          "id": "oc_pan_L_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            550,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.2588"
        }
      },
      {
        "box": {
          "id": "oc_pan_R_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1645,
            550,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.9659"
        }
      },
      {
        "box": {
          "id": "lbl_oc_3",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1720,
            40,
            120,
            22
          ],
          "outlettype": [],
          "text": "--- Ocean G3 ---"
        }
      },
      {
        "box": {
          "id": "lfo_phasor_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1720,
            80,
            132,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "phasor~ 0.013333"
        }
      },
      {
        "box": {
          "id": "lfo_mul2_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1720,
            110,
            55,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 2."
        }
      },
      {
        "box": {
          "id": "lfo_sub1_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1778,
            110,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ -1."
        }
      },
      {
        "box": {
          "id": "lfo_abs_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1836,
            110,
            48,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "abs~"
        }
      },
      {
        "box": {
          "id": "lfo_neg_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1874,
            110,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ -1."
        }
      },
      {
        "box": {
          "id": "lfo_tri_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1932,
            110,
            55,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ 1."
        }
      },
      {
        "box": {
          "id": "lfo_depth_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1990,
            110,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.08"
        }
      },
      {
        "box": {
          "id": "lfo_base_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2058,
            110,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ 0.35"
        }
      },
      {
        "box": {
          "id": "groove_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1720,
            150,
            132,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ ocean3 0"
        }
      },
      {
        "box": {
          "id": "lbl_gr_3",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1785,
            152,
            50,
            22
          ],
          "outlettype": [],
          "text": "groove~"
        }
      },
      {
        "box": {
          "id": "rate_snap_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1720,
            185,
            104,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "snapshot~ 20"
        }
      },
      {
        "box": {
          "id": "rate_comp_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1720,
            215,
            286,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "expr -12. * log($f1 + 0.0001) / 0.6931"
        }
      },
      {
        "box": {
          "id": "ptch_add1_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1720,
            250,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "+ 0."
        }
      },
      {
        "box": {
          "id": "ptch_add2_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1720,
            280,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "+ 0."
        }
      },
      {
        "box": {
          "id": "ptch_sig_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1720,
            310,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0."
        }
      },
      {
        "box": {
          "id": "fs_h_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1720,
            385,
            60,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "hilbert~"
        }
      },
      {
        "box": {
          "id": "fs_ccos_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1800,
            385,
            50,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "cycle~"
        }
      },
      {
        "box": {
          "id": "fs_csin_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1800,
            415,
            50,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "cycle~"
        }
      },
      {
        "box": {
          "id": "fs_cphase_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1800,
            355,
            35,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "0.25"
        }
      },
      {
        "box": {
          "id": "fs_sig_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1865,
            385,
            60,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0.15"
        }
      },
      {
        "box": {
          "id": "fs_mr_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1720,
            450,
            35,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~"
        }
      },
      {
        "box": {
          "id": "fs_mi_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1770,
            450,
            35,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~"
        }
      },
      {
        "box": {
          "id": "fs_ni_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1770,
            480,
            55,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ -1."
        }
      },
      {
        "box": {
          "id": "fs_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1745,
            510,
            35,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "oc_env_cmp_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1810,
            80,
            69,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 120.0"
        }
      },
      {
        "box": {
          "id": "oc_env_once_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1810,
            110,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "change"
        }
      },
      {
        "box": {
          "id": "oc_entry_msg_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1810,
            140,
            70,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "1. 10000"
        }
      },
      {
        "box": {
          "id": "oc_env_line_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1810,
            175,
            111,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "line 0. 10000"
        }
      },
      {
        "box": {
          "id": "oc_fade_cmp_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1810,
            215,
            69,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 660.0"
        }
      },
      {
        "box": {
          "id": "oc_fade_once_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1810,
            245,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "change"
        }
      },
      {
        "box": {
          "id": "oc_fade_msg_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1810,
            275,
            70,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "0. 30000"
        }
      },
      {
        "box": {
          "id": "oc_vol_mult_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1810,
            310,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "* 0."
        }
      },
      {
        "box": {
          "id": "oc_vol_sig_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1810,
            340,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0."
        }
      },
      {
        "box": {
          "id": "oc_vol_mult2_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1720,
            425,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~"
        }
      },
      {
        "box": {
          "id": "oc_pan_L_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1720,
            550,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 1.0000"
        }
      },
      {
        "box": {
          "id": "oc_pan_R_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1805,
            550,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.0000"
        }
      },
      {
        "box": {
          "id": "lbl_oc_4",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1880,
            40,
            120,
            22
          ],
          "outlettype": [],
          "text": "--- Ocean G4 ---"
        }
      },
      {
        "box": {
          "id": "lfo_phasor_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1880,
            80,
            132,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "phasor~ 0.016667"
        }
      },
      {
        "box": {
          "id": "lfo_mul2_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1880,
            110,
            55,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 2."
        }
      },
      {
        "box": {
          "id": "lfo_sub1_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1938,
            110,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ -1."
        }
      },
      {
        "box": {
          "id": "lfo_abs_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1996,
            110,
            48,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "abs~"
        }
      },
      {
        "box": {
          "id": "lfo_neg_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2034,
            110,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ -1."
        }
      },
      {
        "box": {
          "id": "lfo_tri_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2092,
            110,
            55,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ 1."
        }
      },
      {
        "box": {
          "id": "lfo_depth_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2150,
            110,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.1"
        }
      },
      {
        "box": {
          "id": "lfo_base_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2218,
            110,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ 0.55"
        }
      },
      {
        "box": {
          "id": "groove_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1880,
            150,
            132,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ ocean4 0"
        }
      },
      {
        "box": {
          "id": "lbl_gr_4",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1945,
            152,
            50,
            22
          ],
          "outlettype": [],
          "text": "groove~"
        }
      },
      {
        "box": {
          "id": "rate_snap_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1880,
            185,
            104,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "snapshot~ 20"
        }
      },
      {
        "box": {
          "id": "rate_comp_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1880,
            215,
            286,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "expr -12. * log($f1 + 0.0001) / 0.6931"
        }
      },
      {
        "box": {
          "id": "ptch_add1_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1880,
            250,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "+ 0."
        }
      },
      {
        "box": {
          "id": "ptch_add2_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1880,
            280,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "+ 0."
        }
      },
      {
        "box": {
          "id": "ptch_sig_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1880,
            310,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0."
        }
      },
      {
        "box": {
          "id": "fs_h_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1880,
            385,
            60,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "hilbert~"
        }
      },
      {
        "box": {
          "id": "fs_ccos_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1960,
            385,
            50,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "cycle~"
        }
      },
      {
        "box": {
          "id": "fs_csin_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1960,
            415,
            50,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "cycle~"
        }
      },
      {
        "box": {
          "id": "fs_cphase_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1960,
            355,
            35,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "0.25"
        }
      },
      {
        "box": {
          "id": "fs_sig_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2025,
            385,
            60,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0.15"
        }
      },
      {
        "box": {
          "id": "fs_mr_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1880,
            450,
            35,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~"
        }
      },
      {
        "box": {
          "id": "fs_mi_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1930,
            450,
            35,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~"
        }
      },
      {
        "box": {
          "id": "fs_ni_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1930,
            480,
            55,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ -1."
        }
      },
      {
        "box": {
          "id": "fs_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1905,
            510,
            35,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "oc_env_cmp_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1970,
            80,
            69,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 300.0"
        }
      },
      {
        "box": {
          "id": "oc_env_once_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1970,
            110,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "change"
        }
      },
      {
        "box": {
          "id": "oc_entry_msg_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1970,
            140,
            70,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "1. 10000"
        }
      },
      {
        "box": {
          "id": "oc_env_line_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1970,
            175,
            111,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "line 0. 10000"
        }
      },
      {
        "box": {
          "id": "oc_fade_cmp_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1970,
            215,
            69,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 615.0"
        }
      },
      {
        "box": {
          "id": "oc_fade_once_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1970,
            245,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "change"
        }
      },
      {
        "box": {
          "id": "oc_fade_msg_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1970,
            275,
            70,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "0. 30000"
        }
      },
      {
        "box": {
          "id": "oc_vol_mult_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1970,
            310,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "* 0."
        }
      },
      {
        "box": {
          "id": "oc_vol_sig_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1970,
            340,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0."
        }
      },
      {
        "box": {
          "id": "oc_vol_mult2_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1880,
            425,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~"
        }
      },
      {
        "box": {
          "id": "oc_pan_L_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1880,
            550,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.0000"
        }
      },
      {
        "box": {
          "id": "oc_pan_R_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1965,
            550,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 1.0000"
        }
      },
      {
        "box": {
          "id": "lbl_s9",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            2050,
            20,
            160,
            22
          ],
          "outlettype": [],
          "text": "=== MIX & OUTPUT ==="
        }
      },
      {
        "box": {
          "id": "mot_sumL",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2050,
            70,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "mot_sumL2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2050,
            100,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "mot_sumR",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            70,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "mot_sumR2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            100,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "oc_sumL_12",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2050,
            150,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "oc_sumL_34",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2050,
            180,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "oc_sumL_all",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2050,
            210,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "oc_sumR_12",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            150,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "oc_sumR_34",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            180,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "oc_sumR_all",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            210,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "final_L_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2050,
            260,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "final_L_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2050,
            295,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "final_R_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            260,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "final_R_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            295,
            34,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~"
        }
      },
      {
        "box": {
          "id": "master_L",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2050,
            335,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.5"
        }
      },
      {
        "box": {
          "id": "master_R",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            335,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.5"
        }
      },
      {
        "box": {
          "id": "clip_L",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            2050,
            370,
            104,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "clip~ -1. 1."
        }
      },
      {
        "box": {
          "id": "clip_R",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            370,
            104,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "clip~ -1. 1."
        }
      },
      {
        "box": {
          "id": "dac",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2080,
            410,
            60,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "plugout~"
        }
      },
      {
        "box": {
          "id": "meter_L",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2050,
            450,
            60,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "meter~"
        }
      },
      {
        "box": {
          "id": "meter_R",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            450,
            60,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "meter~"
        }
      },
      {
        "box": {
          "id": "lbl_init",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            40,
            900,
            100,
            22
          ],
          "outlettype": [],
          "text": "=== INIT ==="
        }
      },
      {
        "box": {
          "id": "thisdevice",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            40,
            930,
            125,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "live.thisdevice"
        }
      },
      {
        "box": {
          "id": "groove_loop_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1030,
            55,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "loop 1"
        }
      },
      {
        "box": {
          "id": "groove_loop_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1060,
            55,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "loop 1"
        }
      },
      {
        "box": {
          "id": "groove_loop_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1090,
            55,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "loop 1"
        }
      },
      {
        "box": {
          "id": "groove_loop_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1120,
            55,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "loop 1"
        }
      },
      {
        "box": {
          "id": "lb_delay2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1165,
            83,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "delay 600"
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "destination": [
            "dry_gain",
            0
          ],
          "source": [
            "adc",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "msg_start",
            0
          ],
          "source": [
            "start_btn",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "msg_stop",
            0
          ],
          "source": [
            "reset_btn",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "metro",
            0
          ],
          "source": [
            "msg_start",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "metro",
            0
          ],
          "source": [
            "msg_stop",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "counter",
            3
          ],
          "source": [
            "msg_stop",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "counter",
            0
          ],
          "source": [
            "metro",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ticks_ms",
            0
          ],
          "source": [
            "counter",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ms_sec",
            0
          ],
          "source": [
            "ticks_ms",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "t_disp",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 0
        }
      },
      {
        "patchline": {
          "destination": [
            "t_min",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 1
        }
      },
      {
        "patchline": {
          "destination": [
            "evo_div",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 2
        }
      },
      {
        "patchline": {
          "destination": [
            "cg_sub",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 3
        }
      },
      {
        "patchline": {
          "destination": [
            "onset_div",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 4
        }
      },
      {
        "patchline": {
          "destination": [
            "min_disp",
            0
          ],
          "source": [
            "t_min",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "evo_clip",
            0
          ],
          "source": [
            "evo_div",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "cg_sign",
            0
          ],
          "source": [
            "cg_sub",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "onset_clip",
            0
          ],
          "source": [
            "onset_div",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rms_fast",
            0
          ],
          "source": [
            "adc",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rms_slow_raw",
            0
          ],
          "source": [
            "adc",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rms_slow_lp",
            0
          ],
          "source": [
            "rms_slow_raw",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rms_fast_sig2ctl",
            0
          ],
          "source": [
            "rms_fast",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rms_slow_sig2ctl",
            0
          ],
          "source": [
            "rms_slow_lp",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "swell_add_eps",
            0
          ],
          "source": [
            "rms_fast_sig2ctl",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "swell_ratio",
            0
          ],
          "source": [
            "rms_slow_sig2ctl",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "swell_ratio",
            1
          ],
          "source": [
            "swell_add_eps",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tex_sub",
            0
          ],
          "source": [
            "swell_ratio",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tex_div",
            0
          ],
          "source": [
            "tex_sub",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tex_clip",
            0
          ],
          "source": [
            "tex_div",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tex_line",
            0
          ],
          "source": [
            "tex_clip",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "yin",
            0
          ],
          "source": [
            "adc",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "conf_gate",
            0
          ],
          "source": [
            "yin",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "conf_thresh",
            0
          ],
          "source": [
            "yin",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "conf_gate",
            1
          ],
          "source": [
            "conf_thresh",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "cents_div",
            0
          ],
          "source": [
            "conf_gate",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "semi_int",
            0
          ],
          "source": [
            "cents_div",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "semi_change",
            0
          ],
          "source": [
            "semi_int",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "root_line",
            0
          ],
          "source": [
            "semi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "root_disp",
            0
          ],
          "source": [
            "root_line",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pre1_cmp",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 14
        }
      },
      {
        "patchline": {
          "destination": [
            "pre2_cmp",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 15
        }
      },
      {
        "patchline": {
          "destination": [
            "pre1_once",
            0
          ],
          "source": [
            "pre1_cmp",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "preset_msg_1",
            0
          ],
          "source": [
            "pre1_once",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pre2_once",
            0
          ],
          "source": [
            "pre2_cmp",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "preset_msg_2",
            0
          ],
          "source": [
            "pre2_once",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "preset_route",
            0
          ],
          "source": [
            "preset_msg_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "preset_route",
            0
          ],
          "source": [
            "preset_msg_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "preset_route",
            0
          ],
          "source": [
            "preset_msg_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "preset_route",
            0
          ],
          "source": [
            "preset_msg_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "preset_unpack",
            0
          ],
          "source": [
            "preset_route",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "poff_store_1",
            0
          ],
          "source": [
            "preset_unpack",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "poff_store_2",
            0
          ],
          "source": [
            "preset_unpack",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "poff_store_3",
            0
          ],
          "source": [
            "preset_unpack",
            2
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "poff_store_4",
            0
          ],
          "source": [
            "preset_unpack",
            3
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tapin",
            0
          ],
          "source": [
            "adc",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "mot_onset_sig",
            0
          ],
          "source": [
            "onset_clip",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "mot_vol_mult",
            0
          ],
          "source": [
            "mot_onset_sig",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "mot_vol_mult",
            1
          ],
          "source": [
            "mot_vol_line",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tapout_0",
            0
          ],
          "source": [
            "tapin",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tap_lp_0",
            0
          ],
          "source": [
            "tapout_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tap_vol_0",
            0
          ],
          "source": [
            "tap_lp_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tap_vol_0",
            1
          ],
          "source": [
            "mot_vol_mult",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tapout_1",
            0
          ],
          "source": [
            "tapin",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tap_lp_1",
            0
          ],
          "source": [
            "tapout_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tap_vol_1",
            0
          ],
          "source": [
            "tap_lp_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tap_vol_1",
            1
          ],
          "source": [
            "mot_vol_mult",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tapout_2",
            0
          ],
          "source": [
            "tapin",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tap_lp_2",
            0
          ],
          "source": [
            "tapout_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tap_vol_2",
            0
          ],
          "source": [
            "tap_lp_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "tap_vol_2",
            1
          ],
          "source": [
            "mot_vol_mult",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "cap_tex_line",
            0
          ],
          "source": [
            "tex_line",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "cap_gate_float",
            0
          ],
          "source": [
            "cap_tex_line",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "cap_gate_float",
            1
          ],
          "source": [
            "cg_sign",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "cap_threshold",
            0
          ],
          "source": [
            "cap_gate_float",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ocean_rec_1",
            1
          ],
          "source": [
            "cap_threshold",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ocean_rec_1",
            0
          ],
          "source": [
            "adc",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ocean_rec_2",
            1
          ],
          "source": [
            "cap_threshold",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ocean_rec_2",
            0
          ],
          "source": [
            "adc",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ocean_rec_3",
            1
          ],
          "source": [
            "cap_threshold",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ocean_rec_3",
            0
          ],
          "source": [
            "adc",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ocean_rec_4",
            1
          ],
          "source": [
            "cap_threshold",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ocean_rec_4",
            0
          ],
          "source": [
            "adc",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "od_fade_cmp",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 5
        }
      },
      {
        "patchline": {
          "destination": [
            "od_fade_once",
            0
          ],
          "source": [
            "od_fade_cmp",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "od_fade_msg",
            0
          ],
          "source": [
            "od_fade_once",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "od_ramp_down",
            0
          ],
          "source": [
            "od_fade_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "msg_od_ramp_start",
            0
          ],
          "source": [
            "start_btn",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "od_ramp_up",
            0
          ],
          "source": [
            "msg_od_ramp_start",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ocean_depth_val",
            0
          ],
          "source": [
            "od_ramp_up",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ocean_depth_val",
            0
          ],
          "source": [
            "od_ramp_down",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_mul2_1",
            0
          ],
          "source": [
            "lfo_phasor_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_sub1_1",
            0
          ],
          "source": [
            "lfo_mul2_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_abs_1",
            0
          ],
          "source": [
            "lfo_sub1_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_neg_1",
            0
          ],
          "source": [
            "lfo_abs_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_tri_1",
            0
          ],
          "source": [
            "lfo_neg_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_depth_1",
            0
          ],
          "source": [
            "lfo_tri_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_base_1",
            0
          ],
          "source": [
            "lfo_depth_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "groove_1",
            1
          ],
          "source": [
            "lfo_base_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rate_snap_1",
            0
          ],
          "source": [
            "lfo_base_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rate_comp_1",
            0
          ],
          "source": [
            "rate_snap_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add1_1",
            0
          ],
          "source": [
            "root_line",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add1_1",
            1
          ],
          "source": [
            "poff_store_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add2_1",
            0
          ],
          "source": [
            "ptch_add1_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add2_1",
            1
          ],
          "source": [
            "rate_comp_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_sig_1",
            0
          ],
          "source": [
            "ptch_add2_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_h_1",
            0
          ],
          "source": [
            "groove_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_ccos_1",
            0
          ],
          "source": [
            "fs_sig_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_csin_1",
            0
          ],
          "source": [
            "fs_sig_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_ccos_1",
            1
          ],
          "source": [
            "fs_cphase_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_cphase_1",
            0
          ],
          "source": [
            "thisdevice",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mr_1",
            0
          ],
          "source": [
            "fs_h_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mr_1",
            1
          ],
          "source": [
            "fs_ccos_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mi_1",
            0
          ],
          "source": [
            "fs_h_1",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mi_1",
            1
          ],
          "source": [
            "fs_csin_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_1",
            0
          ],
          "source": [
            "fs_mr_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_ni_1",
            0
          ],
          "source": [
            "fs_mi_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_1",
            1
          ],
          "source": [
            "fs_ni_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_cmp_1",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 6
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_fade_cmp_1",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 10
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_once_1",
            0
          ],
          "source": [
            "oc_env_cmp_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_entry_msg_1",
            0
          ],
          "source": [
            "oc_env_once_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_line_1",
            0
          ],
          "source": [
            "oc_entry_msg_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_fade_once_1",
            0
          ],
          "source": [
            "oc_fade_cmp_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_fade_msg_1",
            0
          ],
          "source": [
            "oc_fade_once_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_line_1",
            0
          ],
          "source": [
            "oc_fade_msg_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult_1",
            0
          ],
          "source": [
            "oc_env_line_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult_1",
            1
          ],
          "source": [
            "ocean_depth_val",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_sig_1",
            0
          ],
          "source": [
            "oc_vol_mult_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult2_1",
            1
          ],
          "source": [
            "oc_vol_sig_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult2_1",
            0
          ],
          "source": [
            "fs_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_pan_L_1",
            0
          ],
          "source": [
            "oc_vol_mult2_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_pan_R_1",
            0
          ],
          "source": [
            "oc_vol_mult2_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_mul2_2",
            0
          ],
          "source": [
            "lfo_phasor_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_sub1_2",
            0
          ],
          "source": [
            "lfo_mul2_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_abs_2",
            0
          ],
          "source": [
            "lfo_sub1_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_neg_2",
            0
          ],
          "source": [
            "lfo_abs_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_tri_2",
            0
          ],
          "source": [
            "lfo_neg_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_depth_2",
            0
          ],
          "source": [
            "lfo_tri_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_base_2",
            0
          ],
          "source": [
            "lfo_depth_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "groove_2",
            1
          ],
          "source": [
            "lfo_base_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rate_snap_2",
            0
          ],
          "source": [
            "lfo_base_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rate_comp_2",
            0
          ],
          "source": [
            "rate_snap_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add1_2",
            0
          ],
          "source": [
            "root_line",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add1_2",
            1
          ],
          "source": [
            "poff_store_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add2_2",
            0
          ],
          "source": [
            "ptch_add1_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add2_2",
            1
          ],
          "source": [
            "rate_comp_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_sig_2",
            0
          ],
          "source": [
            "ptch_add2_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_h_2",
            0
          ],
          "source": [
            "groove_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_ccos_2",
            0
          ],
          "source": [
            "fs_sig_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_csin_2",
            0
          ],
          "source": [
            "fs_sig_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_ccos_2",
            1
          ],
          "source": [
            "fs_cphase_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_cphase_2",
            0
          ],
          "source": [
            "thisdevice",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mr_2",
            0
          ],
          "source": [
            "fs_h_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mr_2",
            1
          ],
          "source": [
            "fs_ccos_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mi_2",
            0
          ],
          "source": [
            "fs_h_2",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mi_2",
            1
          ],
          "source": [
            "fs_csin_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_2",
            0
          ],
          "source": [
            "fs_mr_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_ni_2",
            0
          ],
          "source": [
            "fs_mi_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_2",
            1
          ],
          "source": [
            "fs_ni_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_cmp_2",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 7
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_fade_cmp_2",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 11
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_once_2",
            0
          ],
          "source": [
            "oc_env_cmp_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_entry_msg_2",
            0
          ],
          "source": [
            "oc_env_once_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_line_2",
            0
          ],
          "source": [
            "oc_entry_msg_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_fade_once_2",
            0
          ],
          "source": [
            "oc_fade_cmp_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_fade_msg_2",
            0
          ],
          "source": [
            "oc_fade_once_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_line_2",
            0
          ],
          "source": [
            "oc_fade_msg_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult_2",
            0
          ],
          "source": [
            "oc_env_line_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult_2",
            1
          ],
          "source": [
            "ocean_depth_val",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_sig_2",
            0
          ],
          "source": [
            "oc_vol_mult_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult2_2",
            1
          ],
          "source": [
            "oc_vol_sig_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult2_2",
            0
          ],
          "source": [
            "fs_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_pan_L_2",
            0
          ],
          "source": [
            "oc_vol_mult2_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_pan_R_2",
            0
          ],
          "source": [
            "oc_vol_mult2_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_mul2_3",
            0
          ],
          "source": [
            "lfo_phasor_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_sub1_3",
            0
          ],
          "source": [
            "lfo_mul2_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_abs_3",
            0
          ],
          "source": [
            "lfo_sub1_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_neg_3",
            0
          ],
          "source": [
            "lfo_abs_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_tri_3",
            0
          ],
          "source": [
            "lfo_neg_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_depth_3",
            0
          ],
          "source": [
            "lfo_tri_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_base_3",
            0
          ],
          "source": [
            "lfo_depth_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "groove_3",
            1
          ],
          "source": [
            "lfo_base_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rate_snap_3",
            0
          ],
          "source": [
            "lfo_base_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rate_comp_3",
            0
          ],
          "source": [
            "rate_snap_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add1_3",
            0
          ],
          "source": [
            "root_line",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add1_3",
            1
          ],
          "source": [
            "poff_store_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add2_3",
            0
          ],
          "source": [
            "ptch_add1_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add2_3",
            1
          ],
          "source": [
            "rate_comp_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_sig_3",
            0
          ],
          "source": [
            "ptch_add2_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_h_3",
            0
          ],
          "source": [
            "groove_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_ccos_3",
            0
          ],
          "source": [
            "fs_sig_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_csin_3",
            0
          ],
          "source": [
            "fs_sig_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_ccos_3",
            1
          ],
          "source": [
            "fs_cphase_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_cphase_3",
            0
          ],
          "source": [
            "thisdevice",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mr_3",
            0
          ],
          "source": [
            "fs_h_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mr_3",
            1
          ],
          "source": [
            "fs_ccos_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mi_3",
            0
          ],
          "source": [
            "fs_h_3",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mi_3",
            1
          ],
          "source": [
            "fs_csin_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_3",
            0
          ],
          "source": [
            "fs_mr_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_ni_3",
            0
          ],
          "source": [
            "fs_mi_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_3",
            1
          ],
          "source": [
            "fs_ni_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_cmp_3",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 8
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_fade_cmp_3",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 12
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_once_3",
            0
          ],
          "source": [
            "oc_env_cmp_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_entry_msg_3",
            0
          ],
          "source": [
            "oc_env_once_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_line_3",
            0
          ],
          "source": [
            "oc_entry_msg_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_fade_once_3",
            0
          ],
          "source": [
            "oc_fade_cmp_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_fade_msg_3",
            0
          ],
          "source": [
            "oc_fade_once_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_line_3",
            0
          ],
          "source": [
            "oc_fade_msg_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult_3",
            0
          ],
          "source": [
            "oc_env_line_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult_3",
            1
          ],
          "source": [
            "ocean_depth_val",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_sig_3",
            0
          ],
          "source": [
            "oc_vol_mult_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult2_3",
            1
          ],
          "source": [
            "oc_vol_sig_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult2_3",
            0
          ],
          "source": [
            "fs_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_pan_L_3",
            0
          ],
          "source": [
            "oc_vol_mult2_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_pan_R_3",
            0
          ],
          "source": [
            "oc_vol_mult2_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_mul2_4",
            0
          ],
          "source": [
            "lfo_phasor_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_sub1_4",
            0
          ],
          "source": [
            "lfo_mul2_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_abs_4",
            0
          ],
          "source": [
            "lfo_sub1_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_neg_4",
            0
          ],
          "source": [
            "lfo_abs_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_tri_4",
            0
          ],
          "source": [
            "lfo_neg_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_depth_4",
            0
          ],
          "source": [
            "lfo_tri_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lfo_base_4",
            0
          ],
          "source": [
            "lfo_depth_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "groove_4",
            1
          ],
          "source": [
            "lfo_base_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rate_snap_4",
            0
          ],
          "source": [
            "lfo_base_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rate_comp_4",
            0
          ],
          "source": [
            "rate_snap_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add1_4",
            0
          ],
          "source": [
            "root_line",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add1_4",
            1
          ],
          "source": [
            "poff_store_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add2_4",
            0
          ],
          "source": [
            "ptch_add1_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_add2_4",
            1
          ],
          "source": [
            "rate_comp_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ptch_sig_4",
            0
          ],
          "source": [
            "ptch_add2_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_h_4",
            0
          ],
          "source": [
            "groove_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_ccos_4",
            0
          ],
          "source": [
            "fs_sig_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_csin_4",
            0
          ],
          "source": [
            "fs_sig_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_ccos_4",
            1
          ],
          "source": [
            "fs_cphase_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_cphase_4",
            0
          ],
          "source": [
            "thisdevice",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mr_4",
            0
          ],
          "source": [
            "fs_h_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mr_4",
            1
          ],
          "source": [
            "fs_ccos_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mi_4",
            0
          ],
          "source": [
            "fs_h_4",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_mi_4",
            1
          ],
          "source": [
            "fs_csin_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_4",
            0
          ],
          "source": [
            "fs_mr_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_ni_4",
            0
          ],
          "source": [
            "fs_mi_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fs_4",
            1
          ],
          "source": [
            "fs_ni_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_cmp_4",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 9
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_fade_cmp_4",
            0
          ],
          "source": [
            "ms_sec",
            0
          ],
          "order": 13
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_once_4",
            0
          ],
          "source": [
            "oc_env_cmp_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_entry_msg_4",
            0
          ],
          "source": [
            "oc_env_once_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_line_4",
            0
          ],
          "source": [
            "oc_entry_msg_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_fade_once_4",
            0
          ],
          "source": [
            "oc_fade_cmp_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_fade_msg_4",
            0
          ],
          "source": [
            "oc_fade_once_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_env_line_4",
            0
          ],
          "source": [
            "oc_fade_msg_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult_4",
            0
          ],
          "source": [
            "oc_env_line_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult_4",
            1
          ],
          "source": [
            "ocean_depth_val",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_sig_4",
            0
          ],
          "source": [
            "oc_vol_mult_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult2_4",
            1
          ],
          "source": [
            "oc_vol_sig_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_vol_mult2_4",
            0
          ],
          "source": [
            "fs_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_pan_L_4",
            0
          ],
          "source": [
            "oc_vol_mult2_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_pan_R_4",
            0
          ],
          "source": [
            "oc_vol_mult2_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "mot_sumL",
            0
          ],
          "source": [
            "tap_vol_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "mot_sumL",
            1
          ],
          "source": [
            "tap_vol_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "mot_sumR",
            0
          ],
          "source": [
            "tap_vol_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "mot_sumR",
            1
          ],
          "source": [
            "tap_vol_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "mot_sumL2",
            0
          ],
          "source": [
            "tap_vol_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "mot_sumL2",
            1
          ],
          "source": [
            "mot_sumL",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "mot_sumR2",
            0
          ],
          "source": [
            "tap_vol_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "mot_sumR2",
            1
          ],
          "source": [
            "mot_sumR",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_sumL_12",
            0
          ],
          "source": [
            "oc_pan_L_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_sumR_12",
            0
          ],
          "source": [
            "oc_pan_R_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_sumL_12",
            1
          ],
          "source": [
            "oc_pan_L_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_sumR_12",
            1
          ],
          "source": [
            "oc_pan_R_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_sumL_34",
            0
          ],
          "source": [
            "oc_pan_L_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_sumR_34",
            0
          ],
          "source": [
            "oc_pan_R_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_sumL_34",
            1
          ],
          "source": [
            "oc_pan_L_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_sumR_34",
            1
          ],
          "source": [
            "oc_pan_R_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_sumL_all",
            0
          ],
          "source": [
            "oc_sumL_12",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_sumL_all",
            1
          ],
          "source": [
            "oc_sumL_34",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_sumR_all",
            0
          ],
          "source": [
            "oc_sumR_12",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "oc_sumR_all",
            1
          ],
          "source": [
            "oc_sumR_34",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "final_L_1",
            0
          ],
          "source": [
            "dry_gain",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "final_L_1",
            1
          ],
          "source": [
            "mot_sumL2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "final_R_1",
            0
          ],
          "source": [
            "dry_gain",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "final_R_1",
            1
          ],
          "source": [
            "mot_sumR2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "final_L_2",
            0
          ],
          "source": [
            "final_L_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "final_L_2",
            1
          ],
          "source": [
            "oc_sumL_all",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "final_R_2",
            0
          ],
          "source": [
            "final_R_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "final_R_2",
            1
          ],
          "source": [
            "oc_sumR_all",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "master_L",
            0
          ],
          "source": [
            "final_L_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "master_R",
            0
          ],
          "source": [
            "final_R_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "clip_L",
            0
          ],
          "source": [
            "master_L",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "clip_R",
            0
          ],
          "source": [
            "master_R",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "dac",
            0
          ],
          "source": [
            "clip_L",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "dac",
            1
          ],
          "source": [
            "clip_R",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "meter_L",
            0
          ],
          "source": [
            "clip_L",
            0
          ],
          "order": 0
        }
      },
      {
        "patchline": {
          "destination": [
            "meter_R",
            0
          ],
          "source": [
            "clip_R",
            0
          ],
          "order": 0
        }
      },
      {
        "patchline": {
          "destination": [
            "groove_loop_1",
            0
          ],
          "source": [
            "thisdevice",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "groove_1",
            0
          ],
          "source": [
            "groove_loop_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "groove_loop_2",
            0
          ],
          "source": [
            "thisdevice",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "groove_2",
            0
          ],
          "source": [
            "groove_loop_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "groove_loop_3",
            0
          ],
          "source": [
            "thisdevice",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "groove_3",
            0
          ],
          "source": [
            "groove_loop_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "groove_loop_4",
            0
          ],
          "source": [
            "thisdevice",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "groove_4",
            0
          ],
          "source": [
            "groove_loop_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lb_delay2",
            0
          ],
          "source": [
            "thisdevice",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "preset_msg_0",
            0
          ],
          "source": [
            "lb_delay2",
            0
          ]
        }
      }
    ],
    "dependency_cache": [],
    "autosave": 0
  }
}