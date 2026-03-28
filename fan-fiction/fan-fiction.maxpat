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
      2800,
      1400
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
    "description": "Fan Fiction - Reich-style phasing guitar quintet with tonal drift and sample triggers",
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
          "id": "adc_hl",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            108,
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
          "id": "adc_hr",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            133,
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
          "id": "adc_sum",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            125,
            118,
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
          "id": "lbl_mono",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            175,
            120,
            80,
            22
          ],
          "outlettype": [],
          "text": "L+R mono"
        }
      },
      {
        "box": {
          "id": "in_gain",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            165,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.45"
        }
      },
      {
        "box": {
          "id": "lbl_ingain",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            105,
            167,
            230,
            22
          ],
          "outlettype": [],
          "text": "input -6dB (sits under phase bed)"
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
            260,
            22
          ],
          "outlettype": [],
          "text": "=== TIMER + ARCS (600s = 10min) ==="
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
            60,
            22
          ],
          "outlettype": [],
          "text": "RESET"
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
          "id": "onset_div",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            300,
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
          "id": "lbl_onset",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            360,
            332,
            160,
            22
          ],
          "outlettype": [],
          "text": "onset 0..1 (3s ramp)"
        }
      },
      {
        "box": {
          "id": "fade_sub",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            370,
            69,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "- 570.0"
        }
      },
      {
        "box": {
          "id": "fade_div",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            280,
            400,
            62,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "/ 30.0"
        }
      },
      {
        "box": {
          "id": "fade_clip",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            280,
            430,
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
          "id": "fade_inv_mul",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            280,
            460,
            55,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "* -1."
        }
      },
      {
        "box": {
          "id": "fade_inv_add",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            335,
            460,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "+ 1."
        }
      },
      {
        "box": {
          "id": "lbl_fade",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            395,
            462,
            180,
            22
          ],
          "outlettype": [],
          "text": "fade-out 0..1 (inverted)"
        }
      },
      {
        "box": {
          "id": "lbl_s3",
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
          "text": "=== PHRASE CAPTURE ==="
        }
      },
      {
        "box": {
          "id": "buf_phrase",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            560,
            80,
            160,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "buffer~ phrase 23333"
        }
      },
      {
        "box": {
          "id": "lbl_buf",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            670,
            82,
            160,
            22
          ],
          "outlettype": [],
          "text": "phrase buffer (23333ms)"
        }
      },
      {
        "box": {
          "id": "rec_phrase",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            560,
            120,
            118,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "record~ phrase"
        }
      },
      {
        "box": {
          "id": "lbl_rec",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            660,
            122,
            120,
            22
          ],
          "outlettype": [],
          "text": "phrase recorder"
        }
      },
      {
        "box": {
          "id": "cap_open_cmp",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            560,
            165,
            69,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 5.333"
        }
      },
      {
        "box": {
          "id": "cap_open_once",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            560,
            195,
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
          "id": "cap_open_msg",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            560,
            225,
            24,
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
          "id": "lbl_capopen",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            595,
            227,
            150,
            22
          ],
          "outlettype": [],
          "text": "open rec at 5.3s"
        }
      },
      {
        "box": {
          "id": "cap_close_cmp",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            560,
            265,
            76,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 26.666"
        }
      },
      {
        "box": {
          "id": "cap_close_once",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            560,
            295,
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
          "id": "cap_close_msg",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            560,
            325,
            24,
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
          "id": "lbl_capclose",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            595,
            327,
            160,
            22
          ],
          "outlettype": [],
          "text": "close rec at 26.7s"
        }
      },
      {
        "box": {
          "id": "loop_len_msg",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            560,
            365,
            130,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "looplength 21333"
        }
      },
      {
        "box": {
          "id": "lbl_looplen",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            700,
            367,
            140,
            22
          ],
          "outlettype": [],
          "text": "set all loop lengths"
        }
      },
      {
        "box": {
          "id": "lbl_s4",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            820,
            20,
            200,
            22
          ],
          "outlettype": [],
          "text": "=== PITCH DETECTION ==="
        }
      },
      {
        "box": {
          "id": "yin",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            820,
            80,
            111,
            22
          ],
          "outlettype": [
            "float",
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
            930,
            82,
            200,
            22
          ],
          "outlettype": [],
          "text": "yin~ pitch (Hz) + confidence"
        }
      },
      {
        "box": {
          "id": "conf_thresh",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            940,
            120,
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
            820,
            155,
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
          "id": "lbl_cg",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            885,
            157,
            120,
            22
          ],
          "outlettype": [],
          "text": "confidence gate"
        }
      },
      {
        "box": {
          "id": "hz_to_midi",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            820,
            230,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "ftom"
        }
      },
      {
        "box": {
          "id": "midi_int",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            820,
            260,
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
          "id": "midi_change",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            820,
            290,
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
          "id": "midi_disp",
          "maxclass": "flonum",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            820,
            325,
            50,
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
          "id": "lbl_midi",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            875,
            327,
            80,
            22
          ],
          "outlettype": [],
          "text": "MIDI note"
        }
      },
      {
        "box": {
          "id": "bass_hi_cmp",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            920,
            230,
            76,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "< 131.0."
        }
      },
      {
        "box": {
          "id": "bass_lo_cmp",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            920,
            260,
            69,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 87.0."
        }
      },
      {
        "box": {
          "id": "bass_and",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            920,
            290,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "bass_change",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            920,
            320,
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
          "id": "bass_pass1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            920,
            350,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "== 1"
        }
      },
      {
        "box": {
          "id": "lbl_bass",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            985,
            352,
            210,
            22
          ],
          "outlettype": [],
          "text": "bass trigger (fret 1-8 low E)"
        }
      },
      {
        "box": {
          "id": "lbl_s5",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1080,
            20,
            250,
            22
          ],
          "outlettype": [],
          "text": "=== NOTE BANKS + TONAL SHIFT ==="
        }
      },
      {
        "box": {
          "id": "lbl_initbank",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1080,
            40,
            230,
            22
          ],
          "outlettype": [],
          "text": "-- Init Bank (first 5 notes) --"
        }
      },
      {
        "box": {
          "id": "init_bank_0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            70,
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
          "id": "init_default_0",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            100,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "60"
        }
      },
      {
        "box": {
          "id": "init_bank_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            70,
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
          "id": "init_default_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            100,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "64"
        }
      },
      {
        "box": {
          "id": "init_bank_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            70,
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
          "id": "init_default_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            100,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "67"
        }
      },
      {
        "box": {
          "id": "init_bank_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            70,
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
          "id": "init_default_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            100,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "69"
        }
      },
      {
        "box": {
          "id": "init_bank_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            70,
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
          "id": "init_default_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            100,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "62"
        }
      },
      {
        "box": {
          "id": "init_counter",
          "maxclass": "newobj",
          "numinlets": 5,
          "numoutlets": 4,
          "patching_rect": [
            1080,
            140,
            97,
            22
          ],
          "outlettype": [
            "int",
            "",
            "",
            "int"
          ],
          "text": "counter 0 4"
        }
      },
      {
        "box": {
          "id": "init_done",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            170,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "== 4"
        }
      },
      {
        "box": {
          "id": "init_gate",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            200,
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
          "id": "init_sel",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 6,
          "patching_rect": [
            1080,
            235,
            111,
            22
          ],
          "outlettype": [
            "bang",
            "bang",
            "bang",
            "bang",
            "bang",
            ""
          ],
          "text": "sel 0 1 2 3 4"
        }
      },
      {
        "box": {
          "id": "lbl_igate",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1190,
            202,
            200,
            22
          ],
          "outlettype": [],
          "text": "init bank open until 5 notes"
        }
      },
      {
        "box": {
          "id": "lbl_gbanks",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1080,
            290,
            200,
            22
          ],
          "outlettype": [],
          "text": "-- Per-Guitar Banks --"
        }
      },
      {
        "box": {
          "id": "lbl_gb1",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1050,
            320,
            30,
            22
          ],
          "outlettype": [],
          "text": "G1:"
        }
      },
      {
        "box": {
          "id": "g1_bank_0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            320,
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
          "id": "g1_def_0",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            345,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "60"
        }
      },
      {
        "box": {
          "id": "g1_bank_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            320,
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
          "id": "g1_def_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            345,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "64"
        }
      },
      {
        "box": {
          "id": "g1_bank_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            320,
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
          "id": "g1_def_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            345,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "67"
        }
      },
      {
        "box": {
          "id": "g1_bank_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            320,
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
          "id": "g1_def_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            345,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "69"
        }
      },
      {
        "box": {
          "id": "g1_bank_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            320,
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
          "id": "g1_def_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            345,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "62"
        }
      },
      {
        "box": {
          "id": "lbl_gb2",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1050,
            365,
            30,
            22
          ],
          "outlettype": [],
          "text": "G2:"
        }
      },
      {
        "box": {
          "id": "g2_bank_0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            365,
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
          "id": "g2_def_0",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            390,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "60"
        }
      },
      {
        "box": {
          "id": "g2_bank_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            365,
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
          "id": "g2_def_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            390,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "64"
        }
      },
      {
        "box": {
          "id": "g2_bank_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            365,
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
          "id": "g2_def_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            390,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "67"
        }
      },
      {
        "box": {
          "id": "g2_bank_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            365,
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
          "id": "g2_def_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            390,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "69"
        }
      },
      {
        "box": {
          "id": "g2_bank_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            365,
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
          "id": "g2_def_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            390,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "62"
        }
      },
      {
        "box": {
          "id": "lbl_gb3",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1050,
            410,
            30,
            22
          ],
          "outlettype": [],
          "text": "G3:"
        }
      },
      {
        "box": {
          "id": "g3_bank_0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            410,
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
          "id": "g3_def_0",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            435,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "60"
        }
      },
      {
        "box": {
          "id": "g3_bank_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            410,
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
          "id": "g3_def_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            435,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "64"
        }
      },
      {
        "box": {
          "id": "g3_bank_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            410,
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
          "id": "g3_def_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            435,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "67"
        }
      },
      {
        "box": {
          "id": "g3_bank_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            410,
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
          "id": "g3_def_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            435,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "69"
        }
      },
      {
        "box": {
          "id": "g3_bank_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            410,
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
          "id": "g3_def_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            435,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "62"
        }
      },
      {
        "box": {
          "id": "lbl_gb4",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1050,
            455,
            30,
            22
          ],
          "outlettype": [],
          "text": "G4:"
        }
      },
      {
        "box": {
          "id": "g4_bank_0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            455,
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
          "id": "g4_def_0",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            480,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "60"
        }
      },
      {
        "box": {
          "id": "g4_bank_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            455,
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
          "id": "g4_def_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            480,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "64"
        }
      },
      {
        "box": {
          "id": "g4_bank_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            455,
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
          "id": "g4_def_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            480,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "67"
        }
      },
      {
        "box": {
          "id": "g4_bank_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            455,
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
          "id": "g4_def_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            480,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "69"
        }
      },
      {
        "box": {
          "id": "g4_bank_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            455,
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
          "id": "g4_def_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            480,
            30,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "62"
        }
      },
      {
        "box": {
          "id": "lbl_newdet",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1080,
            530,
            200,
            22
          ],
          "outlettype": [],
          "text": "-- New Note Detection --"
        }
      },
      {
        "box": {
          "id": "lbl_nd1",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1050,
            560,
            130,
            22
          ],
          "outlettype": [],
          "text": "G1 new-note check:"
        }
      },
      {
        "box": {
          "id": "g1_neq_0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            585,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g1_neq_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            585,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g1_neq_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            585,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g1_neq_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            585,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g1_neq_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            585,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g1_and_01",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            615,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g1_and_23",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            615,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g1_and_012",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            640,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g1_and_0123",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            640,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g1_all_new",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            665,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g1_new_chg",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1210,
            665,
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
          "id": "g1_new_pass",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1210,
            690,
            55,
            22
          ],
          "outlettype": [
            "bang",
            ""
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "lbl_new1",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1265,
            692,
            140,
            22
          ],
          "outlettype": [],
          "text": "\u2192 new note for G1"
        }
      },
      {
        "box": {
          "id": "lbl_nd2",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1050,
            655,
            130,
            22
          ],
          "outlettype": [],
          "text": "G2 new-note check:"
        }
      },
      {
        "box": {
          "id": "g2_neq_0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            680,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g2_neq_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            680,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g2_neq_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            680,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g2_neq_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            680,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g2_neq_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            680,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g2_and_01",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            710,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g2_and_23",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            710,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g2_and_012",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            735,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g2_and_0123",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            735,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g2_all_new",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            760,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g2_new_chg",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1210,
            760,
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
          "id": "g2_new_pass",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1210,
            785,
            55,
            22
          ],
          "outlettype": [
            "bang",
            ""
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "lbl_new2",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1265,
            787,
            140,
            22
          ],
          "outlettype": [],
          "text": "\u2192 new note for G2"
        }
      },
      {
        "box": {
          "id": "lbl_nd3",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1050,
            750,
            130,
            22
          ],
          "outlettype": [],
          "text": "G3 new-note check:"
        }
      },
      {
        "box": {
          "id": "g3_neq_0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            775,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g3_neq_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            775,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g3_neq_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            775,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g3_neq_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            775,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g3_neq_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            775,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g3_and_01",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            805,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g3_and_23",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            805,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g3_and_012",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            830,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g3_and_0123",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            830,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g3_all_new",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            855,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g3_new_chg",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1210,
            855,
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
          "id": "g3_new_pass",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1210,
            880,
            55,
            22
          ],
          "outlettype": [
            "bang",
            ""
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "lbl_new3",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1265,
            882,
            140,
            22
          ],
          "outlettype": [],
          "text": "\u2192 new note for G3"
        }
      },
      {
        "box": {
          "id": "lbl_nd4",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1050,
            845,
            130,
            22
          ],
          "outlettype": [],
          "text": "G4 new-note check:"
        }
      },
      {
        "box": {
          "id": "g4_neq_0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            870,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g4_neq_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            870,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g4_neq_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            870,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g4_neq_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1245,
            870,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g4_neq_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1300,
            870,
            34,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "!="
        }
      },
      {
        "box": {
          "id": "g4_and_01",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            900,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g4_and_23",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1190,
            900,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g4_and_012",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            925,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g4_and_0123",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            925,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g4_all_new",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1135,
            950,
            48,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "&& 0"
        }
      },
      {
        "box": {
          "id": "g4_new_chg",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1210,
            950,
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
          "id": "g4_new_pass",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1210,
            975,
            55,
            22
          ],
          "outlettype": [
            "bang",
            ""
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "lbl_new4",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1265,
            977,
            140,
            22
          ],
          "outlettype": [],
          "text": "\u2192 new note for G4"
        }
      },
      {
        "box": {
          "id": "lbl_tshift",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1080,
            960,
            220,
            22
          ],
          "outlettype": [],
          "text": "-- Tonal Shift Responses --"
        }
      },
      {
        "box": {
          "id": "lbl_ts1",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1050,
            990,
            200,
            22
          ],
          "outlettype": [],
          "text": "G1 shift (delay 2-6s):"
        }
      },
      {
        "box": {
          "id": "ts_rand_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            1015,
            97,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "random 4001"
        }
      },
      {
        "box": {
          "id": "ts_add_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1160,
            1015,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "+ 2000"
        }
      },
      {
        "box": {
          "id": "ts_pipe_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            1045,
            69,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "delay 0"
        }
      },
      {
        "box": {
          "id": "lbl_tpipe1",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1145,
            1047,
            170,
            22
          ],
          "outlettype": [],
          "text": "delay = bang after N ms"
        }
      },
      {
        "box": {
          "id": "ts_latch_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1230,
            1015,
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
          "id": "lbl_tlatch1",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1265,
            1017,
            100,
            22
          ],
          "outlettype": [],
          "text": "latch new note"
        }
      },
      {
        "box": {
          "id": "ts_rslot_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            1075,
            76,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "random 5"
        }
      },
      {
        "box": {
          "id": "ts_ssel_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 6,
          "patching_rect": [
            1080,
            1105,
            111,
            22
          ],
          "outlettype": [
            "bang",
            "bang",
            "bang",
            "bang",
            "bang",
            ""
          ],
          "text": "sel 0 1 2 3 4"
        }
      },
      {
        "box": {
          "id": "lbl_tssel1",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1255,
            1107,
            90,
            22
          ],
          "outlettype": [],
          "text": "replace slot"
        }
      },
      {
        "box": {
          "id": "ts_tw_1_0",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1080,
            1135,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_1_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1135,
            1135,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_1_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1190,
            1135,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_1_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1245,
            1135,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_1_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1300,
            1135,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_interval_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1310,
            1075,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "- 0."
        }
      },
      {
        "box": {
          "id": "lbl_tint1",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1360,
            1077,
            110,
            22
          ],
          "outlettype": [],
          "text": "semitone shift"
        }
      },
      {
        "box": {
          "id": "ts_pline_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1310,
            1105,
            104,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "line 0. 3000"
        }
      },
      {
        "box": {
          "id": "ts_psig_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1310,
            1135,
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
          "id": "ts_trig_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 4,
          "patching_rect": [
            1130,
            990,
            125,
            22
          ],
          "outlettype": [
            "bang",
            "bang",
            "bang",
            "bang"
          ],
          "text": "trigger b b b b"
        }
      },
      {
        "box": {
          "id": "lbl_ts2",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1050,
            1110,
            200,
            22
          ],
          "outlettype": [],
          "text": "G2 shift (delay 5-15s):"
        }
      },
      {
        "box": {
          "id": "ts_rand_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            1135,
            104,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "random 10001"
        }
      },
      {
        "box": {
          "id": "ts_add_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1160,
            1135,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "+ 5000"
        }
      },
      {
        "box": {
          "id": "ts_pipe_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            1165,
            69,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "delay 0"
        }
      },
      {
        "box": {
          "id": "lbl_tpipe2",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1145,
            1167,
            170,
            22
          ],
          "outlettype": [],
          "text": "delay = bang after N ms"
        }
      },
      {
        "box": {
          "id": "ts_latch_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1230,
            1135,
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
          "id": "lbl_tlatch2",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1265,
            1137,
            100,
            22
          ],
          "outlettype": [],
          "text": "latch new note"
        }
      },
      {
        "box": {
          "id": "ts_rslot_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            1195,
            76,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "random 5"
        }
      },
      {
        "box": {
          "id": "ts_ssel_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 6,
          "patching_rect": [
            1080,
            1225,
            111,
            22
          ],
          "outlettype": [
            "bang",
            "bang",
            "bang",
            "bang",
            "bang",
            ""
          ],
          "text": "sel 0 1 2 3 4"
        }
      },
      {
        "box": {
          "id": "lbl_tssel2",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1255,
            1227,
            90,
            22
          ],
          "outlettype": [],
          "text": "replace slot"
        }
      },
      {
        "box": {
          "id": "ts_tw_2_0",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1080,
            1255,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_2_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1135,
            1255,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_2_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1190,
            1255,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_2_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1245,
            1255,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_2_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1300,
            1255,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_interval_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1310,
            1195,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "- 0."
        }
      },
      {
        "box": {
          "id": "lbl_tint2",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1360,
            1197,
            110,
            22
          ],
          "outlettype": [],
          "text": "semitone shift"
        }
      },
      {
        "box": {
          "id": "ts_pline_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1310,
            1225,
            104,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "line 0. 3000"
        }
      },
      {
        "box": {
          "id": "ts_psig_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1310,
            1255,
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
          "id": "ts_trig_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 4,
          "patching_rect": [
            1130,
            1110,
            125,
            22
          ],
          "outlettype": [
            "bang",
            "bang",
            "bang",
            "bang"
          ],
          "text": "trigger b b b b"
        }
      },
      {
        "box": {
          "id": "lbl_ts3",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1050,
            1230,
            200,
            22
          ],
          "outlettype": [],
          "text": "G3 shift (delay 10-25s):"
        }
      },
      {
        "box": {
          "id": "ts_rand_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            1255,
            104,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "random 15001"
        }
      },
      {
        "box": {
          "id": "ts_add_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1160,
            1255,
            69,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "+ 10000"
        }
      },
      {
        "box": {
          "id": "ts_pipe_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            1285,
            69,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "delay 0"
        }
      },
      {
        "box": {
          "id": "lbl_tpipe3",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1145,
            1287,
            170,
            22
          ],
          "outlettype": [],
          "text": "delay = bang after N ms"
        }
      },
      {
        "box": {
          "id": "ts_latch_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1230,
            1255,
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
          "id": "lbl_tlatch3",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1265,
            1257,
            100,
            22
          ],
          "outlettype": [],
          "text": "latch new note"
        }
      },
      {
        "box": {
          "id": "ts_rslot_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            1315,
            76,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "random 5"
        }
      },
      {
        "box": {
          "id": "ts_ssel_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 6,
          "patching_rect": [
            1080,
            1345,
            111,
            22
          ],
          "outlettype": [
            "bang",
            "bang",
            "bang",
            "bang",
            "bang",
            ""
          ],
          "text": "sel 0 1 2 3 4"
        }
      },
      {
        "box": {
          "id": "lbl_tssel3",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1255,
            1347,
            90,
            22
          ],
          "outlettype": [],
          "text": "replace slot"
        }
      },
      {
        "box": {
          "id": "ts_tw_3_0",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1080,
            1375,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_3_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1135,
            1375,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_3_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1190,
            1375,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_3_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1245,
            1375,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_3_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1300,
            1375,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_interval_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1310,
            1315,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "- 0."
        }
      },
      {
        "box": {
          "id": "lbl_tint3",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1360,
            1317,
            110,
            22
          ],
          "outlettype": [],
          "text": "semitone shift"
        }
      },
      {
        "box": {
          "id": "ts_pline_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1310,
            1345,
            104,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "line 0. 3000"
        }
      },
      {
        "box": {
          "id": "ts_psig_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1310,
            1375,
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
          "id": "ts_trig_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 4,
          "patching_rect": [
            1130,
            1230,
            125,
            22
          ],
          "outlettype": [
            "bang",
            "bang",
            "bang",
            "bang"
          ],
          "text": "trigger b b b b"
        }
      },
      {
        "box": {
          "id": "lbl_ts4",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1050,
            1350,
            200,
            22
          ],
          "outlettype": [],
          "text": "G4 shift (delay 18-35s):"
        }
      },
      {
        "box": {
          "id": "ts_rand_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            1375,
            104,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "random 17001"
        }
      },
      {
        "box": {
          "id": "ts_add_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1160,
            1375,
            69,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "+ 18000"
        }
      },
      {
        "box": {
          "id": "ts_pipe_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            1405,
            69,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "delay 0"
        }
      },
      {
        "box": {
          "id": "lbl_tpipe4",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1145,
            1407,
            170,
            22
          ],
          "outlettype": [],
          "text": "delay = bang after N ms"
        }
      },
      {
        "box": {
          "id": "ts_latch_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1230,
            1375,
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
          "id": "lbl_tlatch4",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1265,
            1377,
            100,
            22
          ],
          "outlettype": [],
          "text": "latch new note"
        }
      },
      {
        "box": {
          "id": "ts_rslot_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1080,
            1435,
            76,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "random 5"
        }
      },
      {
        "box": {
          "id": "ts_ssel_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 6,
          "patching_rect": [
            1080,
            1465,
            111,
            22
          ],
          "outlettype": [
            "bang",
            "bang",
            "bang",
            "bang",
            "bang",
            ""
          ],
          "text": "sel 0 1 2 3 4"
        }
      },
      {
        "box": {
          "id": "lbl_tssel4",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1255,
            1467,
            90,
            22
          ],
          "outlettype": [],
          "text": "replace slot"
        }
      },
      {
        "box": {
          "id": "ts_tw_4_0",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1080,
            1495,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_4_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1135,
            1495,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_4_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1190,
            1495,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_4_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1245,
            1495,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_tw_4_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1300,
            1495,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "ts_interval_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1310,
            1435,
            48,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "- 0."
        }
      },
      {
        "box": {
          "id": "lbl_tint4",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1360,
            1437,
            110,
            22
          ],
          "outlettype": [],
          "text": "semitone shift"
        }
      },
      {
        "box": {
          "id": "ts_pline_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1310,
            1465,
            104,
            22
          ],
          "outlettype": [
            "float"
          ],
          "text": "line 0. 3000"
        }
      },
      {
        "box": {
          "id": "ts_psig_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1310,
            1495,
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
          "id": "ts_trig_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 4,
          "patching_rect": [
            1130,
            1350,
            125,
            22
          ],
          "outlettype": [
            "bang",
            "bang",
            "bang",
            "bang"
          ],
          "text": "trigger b b b b"
        }
      },
      {
        "box": {
          "id": "lbl_s6",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1380,
            20,
            260,
            22
          ],
          "outlettype": [],
          "text": "=== PHASE ENGINE (groove~ voices) ==="
        }
      },
      {
        "box": {
          "id": "lbl_pv1",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1380,
            40,
            115,
            22
          ],
          "outlettype": [],
          "text": "G1 (locked)"
        }
      },
      {
        "box": {
          "id": "gr_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1380,
            80,
            132,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ phrase 0"
        }
      },
      {
        "box": {
          "id": "gr_rate_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1380,
            120,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 1."
        }
      },
      {
        "box": {
          "id": "fs_h_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1380,
            235,
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
            1460,
            235,
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
            1460,
            265,
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
            1460,
            205,
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
            1525,
            235,
            60,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0.05"
        }
      },
      {
        "box": {
          "id": "fs_mr_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1380,
            300,
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
            1430,
            300,
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
            1430,
            330,
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
            1405,
            360,
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
          "id": "entry_cmp_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1380,
            285,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 30.0"
        }
      },
      {
        "box": {
          "id": "entry_once_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1380,
            315,
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
          "id": "entry_split_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1500,
            315,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "gr_start_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1595,
            315,
            72,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "startloop"
        }
      },
      {
        "box": {
          "id": "entry_msg_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1380,
            345,
            60,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "1. 5000"
        }
      },
      {
        "box": {
          "id": "entry_line_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1380,
            375,
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
          "id": "pv_env1_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1380,
            410,
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
          "id": "pv_env2_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1380,
            440,
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
          "id": "pv_vol_sig_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1380,
            470,
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
          "id": "pv_vol_mult_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1380,
            500,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.7"
        }
      },
      {
        "box": {
          "id": "pv_pan_L_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1380,
            535,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.7071"
        }
      },
      {
        "box": {
          "id": "pv_pan_R_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1465,
            535,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.7071"
        }
      },
      {
        "box": {
          "id": "lbl_pv2",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1500,
            40,
            115,
            22
          ],
          "outlettype": [],
          "text": "G2 (slow drift)"
        }
      },
      {
        "box": {
          "id": "gr_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1500,
            80,
            132,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ phrase 0"
        }
      },
      {
        "box": {
          "id": "gr_lfo_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1500,
            120,
            132,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "phasor~ 0.007143"
        }
      },
      {
        "box": {
          "id": "gr_mul2_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1500,
            150,
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
          "id": "gr_sub1_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1558,
            150,
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
          "id": "gr_abs_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1616,
            150,
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
          "id": "gr_neg_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1654,
            150,
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
          "id": "gr_tri_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1712,
            150,
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
          "id": "gr_dep_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1770,
            150,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.04"
        }
      },
      {
        "box": {
          "id": "gr_base_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1838,
            150,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ 0.96"
        }
      },
      {
        "box": {
          "id": "fs_h_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1500,
            235,
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
            1580,
            235,
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
            1580,
            265,
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
            1580,
            205,
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
            1645,
            235,
            60,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0.05"
        }
      },
      {
        "box": {
          "id": "fs_mr_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1500,
            300,
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
            1550,
            300,
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
            1550,
            330,
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
            1525,
            360,
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
          "id": "entry_cmp_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1500,
            285,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 36.0"
        }
      },
      {
        "box": {
          "id": "entry_once_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1500,
            315,
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
          "id": "entry_split_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1620,
            315,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "gr_start_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1715,
            315,
            72,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "startloop"
        }
      },
      {
        "box": {
          "id": "entry_msg_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1500,
            345,
            60,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "1. 5000"
        }
      },
      {
        "box": {
          "id": "entry_line_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1500,
            375,
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
          "id": "pv_env1_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1500,
            410,
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
          "id": "pv_env2_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1500,
            440,
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
          "id": "pv_vol_sig_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1500,
            470,
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
          "id": "pv_vol_mult_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1500,
            500,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.7"
        }
      },
      {
        "box": {
          "id": "pv_pan_L_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1500,
            535,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.9063"
        }
      },
      {
        "box": {
          "id": "pv_pan_R_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1585,
            535,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.4226"
        }
      },
      {
        "box": {
          "id": "lbl_pv3",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1620,
            40,
            115,
            22
          ],
          "outlettype": [],
          "text": "G3 (medium drift)"
        }
      },
      {
        "box": {
          "id": "gr_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1620,
            80,
            132,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ phrase 0"
        }
      },
      {
        "box": {
          "id": "gr_lfo_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1620,
            120,
            132,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "phasor~ 0.005000"
        }
      },
      {
        "box": {
          "id": "gr_mul2_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1620,
            150,
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
          "id": "gr_sub1_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1678,
            150,
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
          "id": "gr_abs_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1736,
            150,
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
          "id": "gr_neg_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1774,
            150,
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
          "id": "gr_tri_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1832,
            150,
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
          "id": "gr_dep_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1890,
            150,
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
          "id": "gr_base_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1958,
            150,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ 0.94"
        }
      },
      {
        "box": {
          "id": "fs_h_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1620,
            235,
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
            1700,
            235,
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
            1700,
            265,
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
            1700,
            205,
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
            1765,
            235,
            60,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0.05"
        }
      },
      {
        "box": {
          "id": "fs_mr_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1620,
            300,
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
            1670,
            300,
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
            1670,
            330,
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
            1645,
            360,
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
          "id": "entry_cmp_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1620,
            285,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 42.0"
        }
      },
      {
        "box": {
          "id": "entry_once_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1620,
            315,
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
          "id": "entry_split_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1740,
            315,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "gr_start_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1835,
            315,
            72,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "startloop"
        }
      },
      {
        "box": {
          "id": "entry_msg_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1620,
            345,
            60,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "1. 5000"
        }
      },
      {
        "box": {
          "id": "entry_line_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1620,
            375,
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
          "id": "pv_env1_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1620,
            410,
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
          "id": "pv_env2_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1620,
            440,
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
          "id": "pv_vol_sig_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1620,
            470,
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
          "id": "pv_vol_mult_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1620,
            500,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.7"
        }
      },
      {
        "box": {
          "id": "pv_pan_L_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1620,
            535,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.4226"
        }
      },
      {
        "box": {
          "id": "pv_pan_R_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1705,
            535,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.9063"
        }
      },
      {
        "box": {
          "id": "lbl_pv4",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1740,
            40,
            115,
            22
          ],
          "outlettype": [],
          "text": "G4 (fast drift)"
        }
      },
      {
        "box": {
          "id": "gr_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1740,
            80,
            132,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ phrase 0"
        }
      },
      {
        "box": {
          "id": "gr_lfo_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1740,
            120,
            132,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "phasor~ 0.010000"
        }
      },
      {
        "box": {
          "id": "gr_mul2_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1740,
            150,
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
          "id": "gr_sub1_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1798,
            150,
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
          "id": "gr_abs_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1856,
            150,
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
          "id": "gr_neg_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1894,
            150,
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
          "id": "gr_tri_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1952,
            150,
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
          "id": "gr_dep_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2010,
            150,
            76,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.025"
        }
      },
      {
        "box": {
          "id": "gr_base_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2078,
            150,
            76,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "+~ 0.975"
        }
      },
      {
        "box": {
          "id": "fs_h_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1740,
            235,
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
            1820,
            235,
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
            1820,
            265,
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
            1820,
            205,
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
            1885,
            235,
            60,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 0.05"
        }
      },
      {
        "box": {
          "id": "fs_mr_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1740,
            300,
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
            1790,
            300,
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
            1790,
            330,
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
            1765,
            360,
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
          "id": "entry_cmp_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1740,
            285,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "> 48.0"
        }
      },
      {
        "box": {
          "id": "entry_once_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1740,
            315,
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
          "id": "entry_split_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1860,
            315,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "gr_start_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1955,
            315,
            72,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "startloop"
        }
      },
      {
        "box": {
          "id": "entry_msg_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1740,
            345,
            60,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "1. 5000"
        }
      },
      {
        "box": {
          "id": "entry_line_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1740,
            375,
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
          "id": "pv_env1_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1740,
            410,
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
          "id": "pv_env2_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1740,
            440,
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
          "id": "pv_vol_sig_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1740,
            470,
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
          "id": "pv_vol_mult_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1740,
            500,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.7"
        }
      },
      {
        "box": {
          "id": "pv_pan_L_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1740,
            535,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.9848"
        }
      },
      {
        "box": {
          "id": "pv_pan_R_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1825,
            535,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.1736"
        }
      },
      {
        "box": {
          "id": "in_pan_L",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1860,
            535,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.7071"
        }
      },
      {
        "box": {
          "id": "in_pan_R",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1945,
            535,
            75,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.7071"
        }
      },
      {
        "box": {
          "id": "lbl_s7",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1900,
            20,
            230,
            22
          ],
          "outlettype": [],
          "text": "=== SAMPLE TRIGGER SYSTEM ==="
        }
      },
      {
        "box": {
          "id": "samp_buf_0",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1900,
            70,
            153,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "buffer~ samp0 10000"
        }
      },
      {
        "box": {
          "id": "samp_read_0",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1900,
            100,
            520,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "read /Users/albanbailly/Documents/guitar-music-msp/fan-fiction/samples/samp_0.wav"
        }
      },
      {
        "box": {
          "id": "samp_buf_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2015,
            70,
            153,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "buffer~ samp1 10000"
        }
      },
      {
        "box": {
          "id": "samp_read_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2015,
            100,
            520,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "read /Users/albanbailly/Documents/guitar-music-msp/fan-fiction/samples/samp_1.wav"
        }
      },
      {
        "box": {
          "id": "samp_buf_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            70,
            153,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "buffer~ samp2 10000"
        }
      },
      {
        "box": {
          "id": "samp_read_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            100,
            520,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "read /Users/albanbailly/Documents/guitar-music-msp/fan-fiction/samples/samp_2.wav"
        }
      },
      {
        "box": {
          "id": "samp_buf_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2245,
            70,
            153,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "buffer~ samp3 10000"
        }
      },
      {
        "box": {
          "id": "samp_read_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2245,
            100,
            520,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "read /Users/albanbailly/Documents/guitar-music-msp/fan-fiction/samples/samp_3.wav"
        }
      },
      {
        "box": {
          "id": "samp_buf_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2360,
            70,
            153,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "buffer~ samp4 10000"
        }
      },
      {
        "box": {
          "id": "samp_read_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2360,
            100,
            520,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "read /Users/albanbailly/Documents/guitar-music-msp/fan-fiction/samples/samp_4.wav"
        }
      },
      {
        "box": {
          "id": "samp_buf_5",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2475,
            70,
            153,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "buffer~ samp5 10000"
        }
      },
      {
        "box": {
          "id": "samp_read_5",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2475,
            100,
            520,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "read /Users/albanbailly/Documents/guitar-music-msp/fan-fiction/samples/samp_5.wav"
        }
      },
      {
        "box": {
          "id": "samp_buf_6",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2590,
            70,
            153,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "buffer~ samp6 10000"
        }
      },
      {
        "box": {
          "id": "samp_read_6",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2590,
            100,
            520,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "read /Users/albanbailly/Documents/guitar-music-msp/fan-fiction/samples/samp_6.wav"
        }
      },
      {
        "box": {
          "id": "samp_buf_7",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2705,
            70,
            153,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "buffer~ samp7 10000"
        }
      },
      {
        "box": {
          "id": "samp_read_7",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2705,
            100,
            520,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "read /Users/albanbailly/Documents/guitar-music-msp/fan-fiction/samples/samp_7.wav"
        }
      },
      {
        "box": {
          "id": "samp_gr_0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1900,
            140,
            125,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ samp0 0"
        }
      },
      {
        "box": {
          "id": "samp_rate_0",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1970,
            130,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 1."
        }
      },
      {
        "box": {
          "id": "samp_gr_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2015,
            140,
            125,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ samp1 0"
        }
      },
      {
        "box": {
          "id": "samp_rate_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2085,
            130,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 1."
        }
      },
      {
        "box": {
          "id": "samp_gr_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2130,
            140,
            125,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ samp2 0"
        }
      },
      {
        "box": {
          "id": "samp_rate_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2200,
            130,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 1."
        }
      },
      {
        "box": {
          "id": "samp_gr_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2245,
            140,
            125,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ samp3 0"
        }
      },
      {
        "box": {
          "id": "samp_rate_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2315,
            130,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 1."
        }
      },
      {
        "box": {
          "id": "samp_gr_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2360,
            140,
            125,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ samp4 0"
        }
      },
      {
        "box": {
          "id": "samp_rate_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2430,
            130,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 1."
        }
      },
      {
        "box": {
          "id": "samp_gr_5",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2475,
            140,
            125,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ samp5 0"
        }
      },
      {
        "box": {
          "id": "samp_rate_5",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2545,
            130,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 1."
        }
      },
      {
        "box": {
          "id": "samp_gr_6",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2590,
            140,
            125,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ samp6 0"
        }
      },
      {
        "box": {
          "id": "samp_rate_6",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2660,
            130,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 1."
        }
      },
      {
        "box": {
          "id": "samp_gr_7",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2705,
            140,
            125,
            22
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "text": "groove~ samp7 0"
        }
      },
      {
        "box": {
          "id": "samp_rate_7",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2775,
            130,
            69,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "sig~ 1."
        }
      },
      {
        "box": {
          "id": "lbl_s7b",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1900,
            195,
            300,
            22
          ],
          "outlettype": [],
          "text": "-- Bass trigger \u2192 random delay \u2192 random sample --"
        }
      },
      {
        "box": {
          "id": "samp_trig_t",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1900,
            225,
            97,
            22
          ],
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "trigger b b"
        }
      },
      {
        "box": {
          "id": "samp_delay_rand",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1900,
            255,
            97,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "random 6001"
        }
      },
      {
        "box": {
          "id": "samp_delay_add",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1980,
            255,
            62,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "+ 2000"
        }
      },
      {
        "box": {
          "id": "samp_pipe",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1900,
            285,
            69,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "delay 0"
        }
      },
      {
        "box": {
          "id": "samp_pick",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1900,
            315,
            76,
            22
          ],
          "outlettype": [
            "int"
          ],
          "text": "random 8"
        }
      },
      {
        "box": {
          "id": "samp_sel",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 9,
          "patching_rect": [
            1900,
            345,
            153,
            22
          ],
          "outlettype": [
            "bang",
            "bang",
            "bang",
            "bang",
            "bang",
            "bang",
            "bang",
            "bang",
            ""
          ],
          "text": "sel 0 1 2 3 4 5 6 7"
        }
      },
      {
        "box": {
          "id": "samp_play_0",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1900,
            385,
            24,
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
          "id": "samp_play_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2015,
            385,
            24,
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
          "id": "samp_play_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            385,
            24,
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
          "id": "samp_play_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2245,
            385,
            24,
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
          "id": "samp_play_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2360,
            385,
            24,
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
          "id": "samp_play_5",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2475,
            385,
            24,
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
          "id": "samp_play_6",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2590,
            385,
            24,
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
          "id": "samp_play_7",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2705,
            385,
            24,
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
          "id": "samp_sumL",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1900,
            430,
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
          "id": "samp_sumL2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1900,
            460,
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
          "id": "samp_sumL3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1900,
            490,
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
          "id": "samp_sumL4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1900,
            520,
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
          "id": "samp_sumR",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1980,
            430,
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
          "id": "samp_sumR2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1980,
            460,
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
          "id": "samp_sumR3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1980,
            490,
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
          "id": "samp_sumR4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1980,
            520,
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
          "id": "samp_vol_0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1900,
            410,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.8"
        }
      },
      {
        "box": {
          "id": "samp_vol_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2015,
            410,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.8"
        }
      },
      {
        "box": {
          "id": "samp_vol_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2130,
            410,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.8"
        }
      },
      {
        "box": {
          "id": "samp_vol_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2245,
            410,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.8"
        }
      },
      {
        "box": {
          "id": "samp_vol_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2360,
            410,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.8"
        }
      },
      {
        "box": {
          "id": "samp_vol_5",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2475,
            410,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.8"
        }
      },
      {
        "box": {
          "id": "samp_vol_6",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2590,
            410,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.8"
        }
      },
      {
        "box": {
          "id": "samp_vol_7",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2705,
            410,
            62,
            22
          ],
          "outlettype": [
            "signal"
          ],
          "text": "*~ 0.8"
        }
      },
      {
        "box": {
          "id": "samp_finalL",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1900,
            550,
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
          "id": "samp_finalR",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1980,
            550,
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
          "id": "samp_chainL_ab",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1900,
            585,
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
          "id": "samp_chainL_cd",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1980,
            585,
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
          "id": "samp_chainL",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1940,
            615,
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
          "id": "samp_chainR_ab",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2060,
            585,
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
          "id": "samp_chainR_cd",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2140,
            585,
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
          "id": "samp_chainR",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2100,
            615,
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
          "id": "lbl_s8",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            2250,
            20,
            170,
            22
          ],
          "outlettype": [],
          "text": "=== MIX & OUTPUT ==="
        }
      },
      {
        "box": {
          "id": "pv_sumL_12",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2250,
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
          "id": "pv_sumL_34",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2250,
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
          "id": "pv_sumL_all",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2250,
            130,
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
          "id": "pv_sumR_12",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2340,
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
          "id": "pv_sumR_34",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2340,
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
          "id": "pv_sumR_all",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2340,
            130,
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
            2250,
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
          "id": "final_L_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2250,
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
          "id": "final_R_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2340,
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
          "id": "final_R_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2340,
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
          "id": "master_L",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2250,
            250,
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
            2340,
            250,
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
            2250,
            285,
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
            2340,
            285,
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
            2290,
            325,
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
            2250,
            365,
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
            2340,
            365,
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
          "id": "gr_loop_1",
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
          "id": "gr_loop_2",
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
          "id": "gr_loop_3",
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
          "id": "gr_loop_4",
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
          "id": "samp_no_loop_0",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1160,
            55,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "loop 0"
        }
      },
      {
        "box": {
          "id": "samp_no_loop_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1190,
            55,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "loop 0"
        }
      },
      {
        "box": {
          "id": "samp_no_loop_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1220,
            55,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "loop 0"
        }
      },
      {
        "box": {
          "id": "samp_no_loop_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1250,
            55,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "loop 0"
        }
      },
      {
        "box": {
          "id": "samp_no_loop_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1280,
            55,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "loop 0"
        }
      },
      {
        "box": {
          "id": "samp_no_loop_5",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1310,
            55,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "loop 0"
        }
      },
      {
        "box": {
          "id": "samp_no_loop_6",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1340,
            55,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "loop 0"
        }
      },
      {
        "box": {
          "id": "samp_no_loop_7",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1370,
            55,
            22
          ],
          "outlettype": [
            ""
          ],
          "text": "loop 0"
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
            1415,
            83,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "delay 700"
        }
      },
      {
        "box": {
          "id": "lb_delay3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            40,
            1450,
            83,
            22
          ],
          "outlettype": [
            "bang"
          ],
          "text": "delay 300"
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "destination": [
            "adc_hl",
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
            "adc_hr",
            0
          ],
          "source": [
            "adc",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "adc_sum",
            0
          ],
          "source": [
            "adc_hl",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "adc_sum",
            1
          ],
          "source": [
            "adc_hr",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "in_gain",
            0
          ],
          "source": [
            "adc_sum",
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
            "onset_div",
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
            "fade_sub",
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
            "fade_div",
            0
          ],
          "source": [
            "fade_sub",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fade_clip",
            0
          ],
          "source": [
            "fade_div",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fade_inv_mul",
            0
          ],
          "source": [
            "fade_clip",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "fade_inv_add",
            0
          ],
          "source": [
            "fade_inv_mul",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "cap_open_cmp",
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
            "cap_close_cmp",
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
            "cap_open_once",
            0
          ],
          "source": [
            "cap_open_cmp",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "cap_open_msg",
            0
          ],
          "source": [
            "cap_open_once",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rec_phrase",
            1
          ],
          "source": [
            "cap_open_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "cap_close_once",
            0
          ],
          "source": [
            "cap_close_cmp",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "cap_close_msg",
            0
          ],
          "source": [
            "cap_close_once",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rec_phrase",
            1
          ],
          "source": [
            "cap_close_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "loop_len_msg",
            0
          ],
          "source": [
            "cap_close_once",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "rec_phrase",
            0
          ],
          "source": [
            "adc_sum",
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
            "adc_sum",
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
            "hz_to_midi",
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
            "midi_int",
            0
          ],
          "source": [
            "hz_to_midi",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "midi_change",
            0
          ],
          "source": [
            "midi_int",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "midi_disp",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "bass_hi_cmp",
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
            "bass_lo_cmp",
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
            "bass_and",
            0
          ],
          "source": [
            "bass_hi_cmp",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "bass_and",
            1
          ],
          "source": [
            "bass_lo_cmp",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "bass_change",
            0
          ],
          "source": [
            "bass_and",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "bass_pass1",
            0
          ],
          "source": [
            "bass_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_0",
            1
          ],
          "source": [
            "init_default_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_1",
            1
          ],
          "source": [
            "init_default_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_2",
            1
          ],
          "source": [
            "init_default_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_3",
            1
          ],
          "source": [
            "init_default_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_4",
            1
          ],
          "source": [
            "init_default_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_gate",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_counter",
            0
          ],
          "source": [
            "init_gate",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_done",
            0
          ],
          "source": [
            "init_counter",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_sel",
            0
          ],
          "source": [
            "init_counter",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_gate",
            1
          ],
          "source": [
            "init_done",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_0",
            1
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_0",
            0
          ],
          "source": [
            "init_sel",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_1",
            1
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_1",
            0
          ],
          "source": [
            "init_sel",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_2",
            1
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_2",
            0
          ],
          "source": [
            "init_sel",
            2
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_3",
            1
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_3",
            0
          ],
          "source": [
            "init_sel",
            3
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_4",
            1
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_bank_4",
            0
          ],
          "source": [
            "init_sel",
            4
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_0",
            1
          ],
          "source": [
            "g1_def_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_0",
            1
          ],
          "source": [
            "init_bank_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_1",
            1
          ],
          "source": [
            "g1_def_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_1",
            1
          ],
          "source": [
            "init_bank_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_2",
            1
          ],
          "source": [
            "g1_def_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_2",
            1
          ],
          "source": [
            "init_bank_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_3",
            1
          ],
          "source": [
            "g1_def_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_3",
            1
          ],
          "source": [
            "init_bank_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_4",
            1
          ],
          "source": [
            "g1_def_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_4",
            1
          ],
          "source": [
            "init_bank_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_0",
            1
          ],
          "source": [
            "g2_def_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_0",
            1
          ],
          "source": [
            "init_bank_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_1",
            1
          ],
          "source": [
            "g2_def_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_1",
            1
          ],
          "source": [
            "init_bank_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_2",
            1
          ],
          "source": [
            "g2_def_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_2",
            1
          ],
          "source": [
            "init_bank_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_3",
            1
          ],
          "source": [
            "g2_def_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_3",
            1
          ],
          "source": [
            "init_bank_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_4",
            1
          ],
          "source": [
            "g2_def_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_4",
            1
          ],
          "source": [
            "init_bank_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_0",
            1
          ],
          "source": [
            "g3_def_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_0",
            1
          ],
          "source": [
            "init_bank_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_1",
            1
          ],
          "source": [
            "g3_def_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_1",
            1
          ],
          "source": [
            "init_bank_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_2",
            1
          ],
          "source": [
            "g3_def_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_2",
            1
          ],
          "source": [
            "init_bank_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_3",
            1
          ],
          "source": [
            "g3_def_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_3",
            1
          ],
          "source": [
            "init_bank_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_4",
            1
          ],
          "source": [
            "g3_def_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_4",
            1
          ],
          "source": [
            "init_bank_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_0",
            1
          ],
          "source": [
            "g4_def_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_0",
            1
          ],
          "source": [
            "init_bank_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_1",
            1
          ],
          "source": [
            "g4_def_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_1",
            1
          ],
          "source": [
            "init_bank_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_2",
            1
          ],
          "source": [
            "g4_def_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_2",
            1
          ],
          "source": [
            "init_bank_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_3",
            1
          ],
          "source": [
            "g4_def_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_3",
            1
          ],
          "source": [
            "init_bank_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_4",
            1
          ],
          "source": [
            "g4_def_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_4",
            1
          ],
          "source": [
            "init_bank_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_neq_0",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_neq_0",
            1
          ],
          "source": [
            "g1_bank_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_neq_1",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_neq_1",
            1
          ],
          "source": [
            "g1_bank_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_neq_2",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_neq_2",
            1
          ],
          "source": [
            "g1_bank_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_neq_3",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_neq_3",
            1
          ],
          "source": [
            "g1_bank_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_neq_4",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_neq_4",
            1
          ],
          "source": [
            "g1_bank_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_and_01",
            0
          ],
          "source": [
            "g1_neq_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_and_01",
            1
          ],
          "source": [
            "g1_neq_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_and_23",
            0
          ],
          "source": [
            "g1_neq_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_and_23",
            1
          ],
          "source": [
            "g1_neq_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_and_0123",
            0
          ],
          "source": [
            "g1_and_01",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_and_0123",
            1
          ],
          "source": [
            "g1_and_23",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_all_new",
            0
          ],
          "source": [
            "g1_and_0123",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_all_new",
            1
          ],
          "source": [
            "g1_neq_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_new_chg",
            0
          ],
          "source": [
            "g1_all_new",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_new_pass",
            0
          ],
          "source": [
            "g1_new_chg",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_neq_0",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_neq_0",
            1
          ],
          "source": [
            "g2_bank_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_neq_1",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_neq_1",
            1
          ],
          "source": [
            "g2_bank_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_neq_2",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_neq_2",
            1
          ],
          "source": [
            "g2_bank_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_neq_3",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_neq_3",
            1
          ],
          "source": [
            "g2_bank_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_neq_4",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_neq_4",
            1
          ],
          "source": [
            "g2_bank_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_and_01",
            0
          ],
          "source": [
            "g2_neq_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_and_01",
            1
          ],
          "source": [
            "g2_neq_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_and_23",
            0
          ],
          "source": [
            "g2_neq_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_and_23",
            1
          ],
          "source": [
            "g2_neq_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_and_0123",
            0
          ],
          "source": [
            "g2_and_01",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_and_0123",
            1
          ],
          "source": [
            "g2_and_23",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_all_new",
            0
          ],
          "source": [
            "g2_and_0123",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_all_new",
            1
          ],
          "source": [
            "g2_neq_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_new_chg",
            0
          ],
          "source": [
            "g2_all_new",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_new_pass",
            0
          ],
          "source": [
            "g2_new_chg",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_neq_0",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_neq_0",
            1
          ],
          "source": [
            "g3_bank_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_neq_1",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_neq_1",
            1
          ],
          "source": [
            "g3_bank_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_neq_2",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_neq_2",
            1
          ],
          "source": [
            "g3_bank_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_neq_3",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_neq_3",
            1
          ],
          "source": [
            "g3_bank_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_neq_4",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_neq_4",
            1
          ],
          "source": [
            "g3_bank_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_and_01",
            0
          ],
          "source": [
            "g3_neq_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_and_01",
            1
          ],
          "source": [
            "g3_neq_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_and_23",
            0
          ],
          "source": [
            "g3_neq_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_and_23",
            1
          ],
          "source": [
            "g3_neq_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_and_0123",
            0
          ],
          "source": [
            "g3_and_01",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_and_0123",
            1
          ],
          "source": [
            "g3_and_23",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_all_new",
            0
          ],
          "source": [
            "g3_and_0123",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_all_new",
            1
          ],
          "source": [
            "g3_neq_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_new_chg",
            0
          ],
          "source": [
            "g3_all_new",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_new_pass",
            0
          ],
          "source": [
            "g3_new_chg",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_neq_0",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_neq_0",
            1
          ],
          "source": [
            "g4_bank_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_neq_1",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_neq_1",
            1
          ],
          "source": [
            "g4_bank_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_neq_2",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_neq_2",
            1
          ],
          "source": [
            "g4_bank_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_neq_3",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_neq_3",
            1
          ],
          "source": [
            "g4_bank_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_neq_4",
            0
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_neq_4",
            1
          ],
          "source": [
            "g4_bank_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_and_01",
            0
          ],
          "source": [
            "g4_neq_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_and_01",
            1
          ],
          "source": [
            "g4_neq_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_and_23",
            0
          ],
          "source": [
            "g4_neq_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_and_23",
            1
          ],
          "source": [
            "g4_neq_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_and_0123",
            0
          ],
          "source": [
            "g4_and_01",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_and_0123",
            1
          ],
          "source": [
            "g4_and_23",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_all_new",
            0
          ],
          "source": [
            "g4_and_0123",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_all_new",
            1
          ],
          "source": [
            "g4_neq_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_new_chg",
            0
          ],
          "source": [
            "g4_all_new",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_new_pass",
            0
          ],
          "source": [
            "g4_new_chg",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_1_0",
            0
          ],
          "source": [
            "ts_ssel_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_1",
            0
          ],
          "source": [
            "ts_tw_1_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_0",
            1
          ],
          "source": [
            "ts_latch_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_0",
            0
          ],
          "source": [
            "ts_latch_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_1_1",
            0
          ],
          "source": [
            "ts_ssel_1",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_1",
            0
          ],
          "source": [
            "ts_tw_1_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_1",
            1
          ],
          "source": [
            "ts_latch_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_1_2",
            0
          ],
          "source": [
            "ts_ssel_1",
            2
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_1",
            0
          ],
          "source": [
            "ts_tw_1_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_2",
            1
          ],
          "source": [
            "ts_latch_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_1_3",
            0
          ],
          "source": [
            "ts_ssel_1",
            3
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_1",
            0
          ],
          "source": [
            "ts_tw_1_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_3",
            1
          ],
          "source": [
            "ts_latch_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_1_4",
            0
          ],
          "source": [
            "ts_ssel_1",
            4
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_1",
            0
          ],
          "source": [
            "ts_tw_1_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_4",
            1
          ],
          "source": [
            "ts_latch_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_trig_1",
            0
          ],
          "source": [
            "g1_new_pass",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_rand_1",
            0
          ],
          "source": [
            "ts_trig_1",
            3
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_1",
            0
          ],
          "source": [
            "ts_trig_1",
            2
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_bank_0",
            0
          ],
          "source": [
            "ts_trig_1",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_pipe_1",
            0
          ],
          "source": [
            "ts_trig_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_1",
            1
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_add_1",
            0
          ],
          "source": [
            "ts_rand_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_pipe_1",
            1
          ],
          "source": [
            "ts_add_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_rslot_1",
            0
          ],
          "source": [
            "ts_pipe_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_ssel_1",
            0
          ],
          "source": [
            "ts_rslot_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_interval_1",
            0
          ],
          "source": [
            "ts_latch_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_interval_1",
            1
          ],
          "source": [
            "g1_bank_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_pline_1",
            0
          ],
          "source": [
            "ts_interval_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_psig_1",
            0
          ],
          "source": [
            "ts_pline_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_2_0",
            0
          ],
          "source": [
            "ts_ssel_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_2",
            0
          ],
          "source": [
            "ts_tw_2_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_0",
            1
          ],
          "source": [
            "ts_latch_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_0",
            0
          ],
          "source": [
            "ts_latch_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_2_1",
            0
          ],
          "source": [
            "ts_ssel_2",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_2",
            0
          ],
          "source": [
            "ts_tw_2_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_1",
            1
          ],
          "source": [
            "ts_latch_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_2_2",
            0
          ],
          "source": [
            "ts_ssel_2",
            2
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_2",
            0
          ],
          "source": [
            "ts_tw_2_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_2",
            1
          ],
          "source": [
            "ts_latch_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_2_3",
            0
          ],
          "source": [
            "ts_ssel_2",
            3
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_2",
            0
          ],
          "source": [
            "ts_tw_2_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_3",
            1
          ],
          "source": [
            "ts_latch_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_2_4",
            0
          ],
          "source": [
            "ts_ssel_2",
            4
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_2",
            0
          ],
          "source": [
            "ts_tw_2_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_4",
            1
          ],
          "source": [
            "ts_latch_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_trig_2",
            0
          ],
          "source": [
            "g2_new_pass",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_rand_2",
            0
          ],
          "source": [
            "ts_trig_2",
            3
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_2",
            0
          ],
          "source": [
            "ts_trig_2",
            2
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_bank_0",
            0
          ],
          "source": [
            "ts_trig_2",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_pipe_2",
            0
          ],
          "source": [
            "ts_trig_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_2",
            1
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_add_2",
            0
          ],
          "source": [
            "ts_rand_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_pipe_2",
            1
          ],
          "source": [
            "ts_add_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_rslot_2",
            0
          ],
          "source": [
            "ts_pipe_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_ssel_2",
            0
          ],
          "source": [
            "ts_rslot_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_interval_2",
            0
          ],
          "source": [
            "ts_latch_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_interval_2",
            1
          ],
          "source": [
            "g2_bank_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_pline_2",
            0
          ],
          "source": [
            "ts_interval_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_psig_2",
            0
          ],
          "source": [
            "ts_pline_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_3_0",
            0
          ],
          "source": [
            "ts_ssel_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_3",
            0
          ],
          "source": [
            "ts_tw_3_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_0",
            1
          ],
          "source": [
            "ts_latch_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_0",
            0
          ],
          "source": [
            "ts_latch_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_3_1",
            0
          ],
          "source": [
            "ts_ssel_3",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_3",
            0
          ],
          "source": [
            "ts_tw_3_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_1",
            1
          ],
          "source": [
            "ts_latch_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_3_2",
            0
          ],
          "source": [
            "ts_ssel_3",
            2
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_3",
            0
          ],
          "source": [
            "ts_tw_3_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_2",
            1
          ],
          "source": [
            "ts_latch_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_3_3",
            0
          ],
          "source": [
            "ts_ssel_3",
            3
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_3",
            0
          ],
          "source": [
            "ts_tw_3_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_3",
            1
          ],
          "source": [
            "ts_latch_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_3_4",
            0
          ],
          "source": [
            "ts_ssel_3",
            4
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_3",
            0
          ],
          "source": [
            "ts_tw_3_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_4",
            1
          ],
          "source": [
            "ts_latch_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_trig_3",
            0
          ],
          "source": [
            "g3_new_pass",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_rand_3",
            0
          ],
          "source": [
            "ts_trig_3",
            3
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_3",
            0
          ],
          "source": [
            "ts_trig_3",
            2
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_bank_0",
            0
          ],
          "source": [
            "ts_trig_3",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_pipe_3",
            0
          ],
          "source": [
            "ts_trig_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_3",
            1
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_add_3",
            0
          ],
          "source": [
            "ts_rand_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_pipe_3",
            1
          ],
          "source": [
            "ts_add_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_rslot_3",
            0
          ],
          "source": [
            "ts_pipe_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_ssel_3",
            0
          ],
          "source": [
            "ts_rslot_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_interval_3",
            0
          ],
          "source": [
            "ts_latch_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_interval_3",
            1
          ],
          "source": [
            "g3_bank_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_pline_3",
            0
          ],
          "source": [
            "ts_interval_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_psig_3",
            0
          ],
          "source": [
            "ts_pline_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_4_0",
            0
          ],
          "source": [
            "ts_ssel_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_4",
            0
          ],
          "source": [
            "ts_tw_4_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_0",
            1
          ],
          "source": [
            "ts_latch_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_0",
            0
          ],
          "source": [
            "ts_latch_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_4_1",
            0
          ],
          "source": [
            "ts_ssel_4",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_4",
            0
          ],
          "source": [
            "ts_tw_4_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_1",
            1
          ],
          "source": [
            "ts_latch_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_4_2",
            0
          ],
          "source": [
            "ts_ssel_4",
            2
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_4",
            0
          ],
          "source": [
            "ts_tw_4_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_2",
            1
          ],
          "source": [
            "ts_latch_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_4_3",
            0
          ],
          "source": [
            "ts_ssel_4",
            3
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_4",
            0
          ],
          "source": [
            "ts_tw_4_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_3",
            1
          ],
          "source": [
            "ts_latch_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_tw_4_4",
            0
          ],
          "source": [
            "ts_ssel_4",
            4
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_4",
            0
          ],
          "source": [
            "ts_tw_4_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_4",
            1
          ],
          "source": [
            "ts_latch_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_trig_4",
            0
          ],
          "source": [
            "g4_new_pass",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_rand_4",
            0
          ],
          "source": [
            "ts_trig_4",
            3
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_4",
            0
          ],
          "source": [
            "ts_trig_4",
            2
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_bank_0",
            0
          ],
          "source": [
            "ts_trig_4",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_pipe_4",
            0
          ],
          "source": [
            "ts_trig_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_latch_4",
            1
          ],
          "source": [
            "midi_change",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_add_4",
            0
          ],
          "source": [
            "ts_rand_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_pipe_4",
            1
          ],
          "source": [
            "ts_add_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_rslot_4",
            0
          ],
          "source": [
            "ts_pipe_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_ssel_4",
            0
          ],
          "source": [
            "ts_rslot_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_interval_4",
            0
          ],
          "source": [
            "ts_latch_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_interval_4",
            1
          ],
          "source": [
            "g4_bank_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_pline_4",
            0
          ],
          "source": [
            "ts_interval_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "ts_psig_4",
            0
          ],
          "source": [
            "ts_pline_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_1",
            0
          ],
          "source": [
            "loop_len_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_1",
            1
          ],
          "source": [
            "gr_rate_1",
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
            "gr_1",
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
            "entry_cmp_1",
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
            "entry_once_1",
            0
          ],
          "source": [
            "entry_cmp_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "entry_split_1",
            0
          ],
          "source": [
            "entry_once_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_start_1",
            0
          ],
          "source": [
            "entry_split_1",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_1",
            0
          ],
          "source": [
            "gr_start_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "entry_msg_1",
            0
          ],
          "source": [
            "entry_split_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "entry_line_1",
            0
          ],
          "source": [
            "entry_msg_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_env1_1",
            0
          ],
          "source": [
            "entry_line_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_env1_1",
            1
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
            "pv_env2_1",
            0
          ],
          "source": [
            "pv_env1_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_env2_1",
            1
          ],
          "source": [
            "fade_inv_add",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_vol_sig_1",
            0
          ],
          "source": [
            "pv_env2_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_vol_mult_1",
            1
          ],
          "source": [
            "pv_vol_sig_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_vol_mult_1",
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
            "pv_pan_L_1",
            0
          ],
          "source": [
            "pv_vol_mult_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_pan_R_1",
            0
          ],
          "source": [
            "pv_vol_mult_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_2",
            0
          ],
          "source": [
            "loop_len_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_mul2_2",
            0
          ],
          "source": [
            "gr_lfo_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_sub1_2",
            0
          ],
          "source": [
            "gr_mul2_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_abs_2",
            0
          ],
          "source": [
            "gr_sub1_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_neg_2",
            0
          ],
          "source": [
            "gr_abs_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_tri_2",
            0
          ],
          "source": [
            "gr_neg_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_dep_2",
            0
          ],
          "source": [
            "gr_tri_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_base_2",
            0
          ],
          "source": [
            "gr_dep_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_2",
            1
          ],
          "source": [
            "gr_base_2",
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
            "gr_2",
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
            "entry_cmp_2",
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
            "entry_once_2",
            0
          ],
          "source": [
            "entry_cmp_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "entry_split_2",
            0
          ],
          "source": [
            "entry_once_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_start_2",
            0
          ],
          "source": [
            "entry_split_2",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_2",
            0
          ],
          "source": [
            "gr_start_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "entry_msg_2",
            0
          ],
          "source": [
            "entry_split_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "entry_line_2",
            0
          ],
          "source": [
            "entry_msg_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_env1_2",
            0
          ],
          "source": [
            "entry_line_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_env1_2",
            1
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
            "pv_env2_2",
            0
          ],
          "source": [
            "pv_env1_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_env2_2",
            1
          ],
          "source": [
            "fade_inv_add",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_vol_sig_2",
            0
          ],
          "source": [
            "pv_env2_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_vol_mult_2",
            1
          ],
          "source": [
            "pv_vol_sig_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_vol_mult_2",
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
            "pv_pan_L_2",
            0
          ],
          "source": [
            "pv_vol_mult_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_pan_R_2",
            0
          ],
          "source": [
            "pv_vol_mult_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_3",
            0
          ],
          "source": [
            "loop_len_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_mul2_3",
            0
          ],
          "source": [
            "gr_lfo_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_sub1_3",
            0
          ],
          "source": [
            "gr_mul2_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_abs_3",
            0
          ],
          "source": [
            "gr_sub1_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_neg_3",
            0
          ],
          "source": [
            "gr_abs_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_tri_3",
            0
          ],
          "source": [
            "gr_neg_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_dep_3",
            0
          ],
          "source": [
            "gr_tri_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_base_3",
            0
          ],
          "source": [
            "gr_dep_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_3",
            1
          ],
          "source": [
            "gr_base_3",
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
            "gr_3",
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
            "entry_cmp_3",
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
            "entry_once_3",
            0
          ],
          "source": [
            "entry_cmp_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "entry_split_3",
            0
          ],
          "source": [
            "entry_once_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_start_3",
            0
          ],
          "source": [
            "entry_split_3",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_3",
            0
          ],
          "source": [
            "gr_start_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "entry_msg_3",
            0
          ],
          "source": [
            "entry_split_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "entry_line_3",
            0
          ],
          "source": [
            "entry_msg_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_env1_3",
            0
          ],
          "source": [
            "entry_line_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_env1_3",
            1
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
            "pv_env2_3",
            0
          ],
          "source": [
            "pv_env1_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_env2_3",
            1
          ],
          "source": [
            "fade_inv_add",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_vol_sig_3",
            0
          ],
          "source": [
            "pv_env2_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_vol_mult_3",
            1
          ],
          "source": [
            "pv_vol_sig_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_vol_mult_3",
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
            "pv_pan_L_3",
            0
          ],
          "source": [
            "pv_vol_mult_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_pan_R_3",
            0
          ],
          "source": [
            "pv_vol_mult_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_4",
            0
          ],
          "source": [
            "loop_len_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_mul2_4",
            0
          ],
          "source": [
            "gr_lfo_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_sub1_4",
            0
          ],
          "source": [
            "gr_mul2_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_abs_4",
            0
          ],
          "source": [
            "gr_sub1_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_neg_4",
            0
          ],
          "source": [
            "gr_abs_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_tri_4",
            0
          ],
          "source": [
            "gr_neg_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_dep_4",
            0
          ],
          "source": [
            "gr_tri_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_base_4",
            0
          ],
          "source": [
            "gr_dep_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_4",
            1
          ],
          "source": [
            "gr_base_4",
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
            "gr_4",
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
            "entry_cmp_4",
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
            "entry_once_4",
            0
          ],
          "source": [
            "entry_cmp_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "entry_split_4",
            0
          ],
          "source": [
            "entry_once_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_start_4",
            0
          ],
          "source": [
            "entry_split_4",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_4",
            0
          ],
          "source": [
            "gr_start_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "entry_msg_4",
            0
          ],
          "source": [
            "entry_split_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "entry_line_4",
            0
          ],
          "source": [
            "entry_msg_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_env1_4",
            0
          ],
          "source": [
            "entry_line_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_env1_4",
            1
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
            "pv_env2_4",
            0
          ],
          "source": [
            "pv_env1_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_env2_4",
            1
          ],
          "source": [
            "fade_inv_add",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_vol_sig_4",
            0
          ],
          "source": [
            "pv_env2_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_vol_mult_4",
            1
          ],
          "source": [
            "pv_vol_sig_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_vol_mult_4",
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
            "pv_pan_L_4",
            0
          ],
          "source": [
            "pv_vol_mult_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_pan_R_4",
            0
          ],
          "source": [
            "pv_vol_mult_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "in_pan_L",
            0
          ],
          "source": [
            "in_gain",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "in_pan_R",
            0
          ],
          "source": [
            "in_gain",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_buf_0",
            0
          ],
          "source": [
            "samp_read_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_buf_1",
            0
          ],
          "source": [
            "samp_read_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_buf_2",
            0
          ],
          "source": [
            "samp_read_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_buf_3",
            0
          ],
          "source": [
            "samp_read_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_buf_4",
            0
          ],
          "source": [
            "samp_read_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_buf_5",
            0
          ],
          "source": [
            "samp_read_5",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_buf_6",
            0
          ],
          "source": [
            "samp_read_6",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_buf_7",
            0
          ],
          "source": [
            "samp_read_7",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_0",
            1
          ],
          "source": [
            "samp_rate_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_1",
            1
          ],
          "source": [
            "samp_rate_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_2",
            1
          ],
          "source": [
            "samp_rate_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_3",
            1
          ],
          "source": [
            "samp_rate_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_4",
            1
          ],
          "source": [
            "samp_rate_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_5",
            1
          ],
          "source": [
            "samp_rate_5",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_6",
            1
          ],
          "source": [
            "samp_rate_6",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_7",
            1
          ],
          "source": [
            "samp_rate_7",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_play_0",
            0
          ],
          "source": [
            "samp_sel",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_0",
            0
          ],
          "source": [
            "samp_play_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_play_1",
            0
          ],
          "source": [
            "samp_sel",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_1",
            0
          ],
          "source": [
            "samp_play_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_play_2",
            0
          ],
          "source": [
            "samp_sel",
            2
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_2",
            0
          ],
          "source": [
            "samp_play_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_play_3",
            0
          ],
          "source": [
            "samp_sel",
            3
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_3",
            0
          ],
          "source": [
            "samp_play_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_play_4",
            0
          ],
          "source": [
            "samp_sel",
            4
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_4",
            0
          ],
          "source": [
            "samp_play_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_play_5",
            0
          ],
          "source": [
            "samp_sel",
            5
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_5",
            0
          ],
          "source": [
            "samp_play_5",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_play_6",
            0
          ],
          "source": [
            "samp_sel",
            6
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_6",
            0
          ],
          "source": [
            "samp_play_6",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_play_7",
            0
          ],
          "source": [
            "samp_sel",
            7
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_gr_7",
            0
          ],
          "source": [
            "samp_play_7",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_vol_0",
            0
          ],
          "source": [
            "samp_gr_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_vol_1",
            0
          ],
          "source": [
            "samp_gr_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_vol_2",
            0
          ],
          "source": [
            "samp_gr_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_vol_3",
            0
          ],
          "source": [
            "samp_gr_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_vol_4",
            0
          ],
          "source": [
            "samp_gr_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_vol_5",
            0
          ],
          "source": [
            "samp_gr_5",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_vol_6",
            0
          ],
          "source": [
            "samp_gr_6",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_vol_7",
            0
          ],
          "source": [
            "samp_gr_7",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumL",
            0
          ],
          "source": [
            "samp_vol_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumL",
            1
          ],
          "source": [
            "samp_vol_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumL2",
            0
          ],
          "source": [
            "samp_vol_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumL2",
            1
          ],
          "source": [
            "samp_vol_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumL3",
            0
          ],
          "source": [
            "samp_vol_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumL3",
            1
          ],
          "source": [
            "samp_vol_5",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumL4",
            0
          ],
          "source": [
            "samp_vol_6",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumL4",
            1
          ],
          "source": [
            "samp_vol_7",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumR",
            0
          ],
          "source": [
            "samp_vol_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumR",
            1
          ],
          "source": [
            "samp_vol_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumR2",
            0
          ],
          "source": [
            "samp_vol_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumR2",
            1
          ],
          "source": [
            "samp_vol_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumR3",
            0
          ],
          "source": [
            "samp_vol_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumR3",
            1
          ],
          "source": [
            "samp_vol_5",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumR4",
            0
          ],
          "source": [
            "samp_vol_6",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumR4",
            1
          ],
          "source": [
            "samp_vol_7",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_finalL",
            0
          ],
          "source": [
            "samp_sumL",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sumL3",
            0
          ],
          "source": [
            "samp_sumL2",
            0
          ],
          "order": 1
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_finalL",
            1
          ],
          "source": [
            "samp_sumL3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_chainL_ab",
            0
          ],
          "source": [
            "samp_sumL",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_chainL_ab",
            1
          ],
          "source": [
            "samp_sumL2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_chainL_cd",
            0
          ],
          "source": [
            "samp_sumL3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_chainL_cd",
            1
          ],
          "source": [
            "samp_sumL4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_chainL",
            0
          ],
          "source": [
            "samp_chainL_ab",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_chainL",
            1
          ],
          "source": [
            "samp_chainL_cd",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_chainR_ab",
            0
          ],
          "source": [
            "samp_sumR",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_chainR_ab",
            1
          ],
          "source": [
            "samp_sumR2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_chainR_cd",
            0
          ],
          "source": [
            "samp_sumR3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_chainR_cd",
            1
          ],
          "source": [
            "samp_sumR4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_chainR",
            0
          ],
          "source": [
            "samp_chainR_ab",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_chainR",
            1
          ],
          "source": [
            "samp_chainR_cd",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_trig_t",
            0
          ],
          "source": [
            "bass_pass1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_delay_rand",
            0
          ],
          "source": [
            "samp_trig_t",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_delay_add",
            0
          ],
          "source": [
            "samp_delay_rand",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_pipe",
            1
          ],
          "source": [
            "samp_delay_add",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_pipe",
            0
          ],
          "source": [
            "samp_trig_t",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_pick",
            0
          ],
          "source": [
            "samp_pipe",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_sel",
            0
          ],
          "source": [
            "samp_pick",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_sumL_12",
            0
          ],
          "source": [
            "pv_pan_L_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_sumR_12",
            0
          ],
          "source": [
            "pv_pan_R_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_sumL_12",
            1
          ],
          "source": [
            "pv_pan_L_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_sumR_12",
            1
          ],
          "source": [
            "pv_pan_R_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_sumL_34",
            0
          ],
          "source": [
            "pv_pan_L_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_sumR_34",
            0
          ],
          "source": [
            "pv_pan_R_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_sumL_34",
            1
          ],
          "source": [
            "pv_pan_L_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_sumR_34",
            1
          ],
          "source": [
            "pv_pan_R_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_sumL_all",
            0
          ],
          "source": [
            "pv_sumL_12",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_sumL_all",
            1
          ],
          "source": [
            "pv_sumL_34",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_sumR_all",
            0
          ],
          "source": [
            "pv_sumR_12",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "pv_sumR_all",
            1
          ],
          "source": [
            "pv_sumR_34",
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
            "pv_sumL_all",
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
            "samp_chainL",
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
            "pv_sumR_all",
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
            "samp_chainR",
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
            "in_pan_L",
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
            "in_pan_R",
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
            "gr_loop_1",
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
            "gr_1",
            0
          ],
          "source": [
            "gr_loop_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_loop_2",
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
            "gr_2",
            0
          ],
          "source": [
            "gr_loop_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_loop_3",
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
            "gr_3",
            0
          ],
          "source": [
            "gr_loop_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "gr_loop_4",
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
            "gr_4",
            0
          ],
          "source": [
            "gr_loop_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_no_loop_0",
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
            "samp_gr_0",
            0
          ],
          "source": [
            "samp_no_loop_0",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_no_loop_1",
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
            "samp_gr_1",
            0
          ],
          "source": [
            "samp_no_loop_1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_no_loop_2",
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
            "samp_gr_2",
            0
          ],
          "source": [
            "samp_no_loop_2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_no_loop_3",
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
            "samp_gr_3",
            0
          ],
          "source": [
            "samp_no_loop_3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_no_loop_4",
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
            "samp_gr_4",
            0
          ],
          "source": [
            "samp_no_loop_4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_no_loop_5",
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
            "samp_gr_5",
            0
          ],
          "source": [
            "samp_no_loop_5",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_no_loop_6",
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
            "samp_gr_6",
            0
          ],
          "source": [
            "samp_no_loop_6",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_no_loop_7",
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
            "samp_gr_7",
            0
          ],
          "source": [
            "samp_no_loop_7",
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
            "samp_read_0",
            0
          ],
          "source": [
            "lb_delay2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_read_1",
            0
          ],
          "source": [
            "lb_delay2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_read_2",
            0
          ],
          "source": [
            "lb_delay2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_read_3",
            0
          ],
          "source": [
            "lb_delay2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_read_4",
            0
          ],
          "source": [
            "lb_delay2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_read_5",
            0
          ],
          "source": [
            "lb_delay2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_read_6",
            0
          ],
          "source": [
            "lb_delay2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "samp_read_7",
            0
          ],
          "source": [
            "lb_delay2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "lb_delay3",
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
            "init_default_0",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_default_1",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_default_2",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_default_3",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "init_default_4",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_def_0",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_def_1",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_def_2",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_def_3",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g1_def_4",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_def_0",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_def_1",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_def_2",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_def_3",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g2_def_4",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_def_0",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_def_1",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_def_2",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_def_3",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g3_def_4",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_def_0",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_def_1",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_def_2",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_def_3",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "g4_def_4",
            0
          ],
          "source": [
            "lb_delay3",
            0
          ]
        }
      }
    ],
    "dependency_cache": [],
    "autosave": 0
  }
}