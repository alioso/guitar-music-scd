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
			800,
			520
		],
		"gridsize": [
			15.0,
			15.0
		],
		"boxes": [
			{
				"box": {
					"id": "adc",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						40,
						40,
						62,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "adc~ 1"
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
						140,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "buffer~ test_buf 5000"
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
						120,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "record~ test_buf"
				}
			},
			{
				"box": {
					"id": "grv",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						40,
						170,
						130,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "groove~ test_buf 0"
				}
			},
			{
				"box": {
					"id": "rate",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						200,
						170,
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
						320,
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
						240,
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
						320,
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
					"id": "lb_delay",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						320,
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
						320,
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
					"id": "rec_loop",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						320,
						185,
						60,
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
					"id": "grv_loop",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						320,
						215,
						60,
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
					"id": "start_btn",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						40,
						300,
						24,
						24
					],
					"outlettype": [
						"bang"
					],
					"parameter_enable": 0
				}
			},
			{
				"box": {
					"id": "lbl_start",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						70,
						304,
						45,
						22
					],
					"outlettype": [],
					"text": "START"
				}
			},
			{
				"box": {
					"id": "start_delay",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						40,
						335,
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
					"id": "rec_start",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						130,
						370,
						20,
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
					"id": "grv_start",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						165,
						370,
						20,
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
					"id": "lbl_info",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						40,
						430,
						560,
						22
					],
					"outlettype": [],
					"text": "1) Click ezdac~   2) Press START   3) Play guitar   4) Wait 5s \u2014 loop should begin"
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
						"lb_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lb_delay",
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
						"rec_loop",
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
						"grv_loop",
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
						"grv_loop",
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
						"start_btn",
						0
					],
					"destination": [
						"start_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"start_delay",
						0
					],
					"destination": [
						"rec_start",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"start_delay",
						0
					],
					"destination": [
						"grv_start",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rec_start",
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
						"grv_start",
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
						"adc",
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
						1
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