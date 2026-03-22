{
	"patcher": {
		"fileversion": 1,
		"appversion": {
			"major": 9,
			"minor": 0,
			"revision": 8,
			"architecture": "x64",
			"modernui": 1
		},
		"classnamespace": "dsp.toplevel",
		"rect": [
			0,
			0,
			700,
			420
		],
		"gridsize": [
			15.0,
			15.0
		],
		"boxes": [
			{
				"box": {
					"id": "tone",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						40,
						40,
						90,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 440"
				}
			},
			{
				"box": {
					"id": "buf",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						40,
						80,
						120,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "buffer~ tb 3000"
				}
			},
			{
				"box": {
					"id": "rec",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						40,
						120,
						100,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "record~ tb"
				}
			},
			{
				"box": {
					"id": "grv",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						40,
						165,
						130,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "groove~ tb 1 @loop 1"
				}
			},
			{
				"box": {
					"id": "rate",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						190,
						165,
						55,
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
					"id": "ezdac",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 0,
					"patching_rect": [
						280,
						40,
						50,
						22
					],
					"outlettype": [],
					"text": "ezdac~"
				}
			},
			{
				"box": {
					"id": "dac",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 0,
					"patching_rect": [
						40,
						230,
						40,
						22
					],
					"outlettype": [],
					"text": "dac~"
				}
			},
			{
				"box": {
					"id": "lb",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						300,
						80,
						76,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"id": "lb_sw",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						300,
						110,
						83,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "delay 100"
				}
			},
			{
				"box": {
					"id": "msg_sw",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						300,
						145,
						91,
						22
					],
					"outlettype": [
						""
					],
					"text": "startwindow"
				}
			},
			{
				"box": {
					"id": "lb_rec",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						300,
						185,
						83,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "delay 200"
				}
			},
			{
				"box": {
					"id": "lb_grv",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						300,
						225,
						90,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "delay 3100"
				}
			},
			{
				"box": {
					"id": "rec_loop",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						300,
						265,
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
					"id": "rec_on",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						370,
						265,
						30,
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
					"id": "grv_on",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						300,
						305,
						70,
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
					"id": "lbl",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						40,
						360,
						520,
						22
					],
					"outlettype": [],
					"text": "Click ezdac~ then wait 3s -- 440Hz tone should loop automatically"
				}
			}
		],
		"lines": [
			{
				"patchline": {
					"source": [
						"lb",
						0
					],
					"destination": [
						"lb_sw",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lb_sw",
						0
					],
					"destination": [
						"msg_sw",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_sw",
						0
					],
					"destination": [
						"dac",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lb",
						0
					],
					"destination": [
						"lb_rec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lb",
						0
					],
					"destination": [
						"lb_grv",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lb_rec",
						0
					],
					"destination": [
						"rec_loop",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lb_rec",
						0
					],
					"destination": [
						"rec_on",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rec_loop",
						0
					],
					"destination": [
						"rec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rec_on",
						0
					],
					"destination": [
						"rec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lb_grv",
						0
					],
					"destination": [
						"grv_on",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"grv_on",
						0
					],
					"destination": [
						"grv",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"tone",
						0
					],
					"destination": [
						"rec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rate",
						0
					],
					"destination": [
						"grv",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"grv",
						0
					],
					"destination": [
						"dac",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"grv",
						0
					],
					"destination": [
						"dac",
						1
					]
				}
			}
		],
		"dependency_cache": [],
		"autosave": 0
	}
}