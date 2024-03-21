package types

type FioReport struct {
	//DiskUtil []struct {
	//	InQueue     int64   `json:"in_queue"`
	//	Name        string  `json:"name"`
	//	ReadIos     int64   `json:"read_ios"`
	//	ReadMerges  int64   `json:"read_merges"`
	//	ReadTicks   int64   `json:"read_ticks"`
	//	Util        float64 `json:"util"`
	//	WriteIos    int64   `json:"write_ios"`
	//	WriteMerges int64   `json:"write_merges"`
	//	WriteTicks  int64   `json:"write_ticks"`
	//} `json:"disk_util"`
	Fio_version    string `json:"fio version"`
	Global_options struct {
		Filename string `json:"filename"`
		Size     string `json:"size"`
	} `json:"global options"`
	Jobs      []FioJob `json:"jobs"`
	Time      string   `json:"time"`
	Timestamp int64    `json:"timestamp"`
	//TimestampMs int64  `json:"timestamp_ms"`
}

type FioJob struct {
	//Ctx     int64 `json:"ctx"`
	Elapsed int64 `json:"elapsed"`
	Error   int64 `json:"error"`
	//Eta     int64 `json:"eta"`
	//Groupid int64 `json:"groupid"`
	//IodepthComplete struct {
	//	Zero        int64   `json:"0"`
	//	One6        int64   `json:"16"`
	//	Three2      int64   `json:"32"`
	//	Four        int64   `json:"4"`
	//	Six4        float64 `json:"64"`
	//	Eight       int64   `json:"8"`
	//	GreaterSix4 int64   `json:">=64"`
	//} `json:"iodepth_complete"`
	//IodepthLevel struct {
	//	One         int64 `json:"1"`
	//	One6        int64 `json:"16"`
	//	Two         int64 `json:"2"`
	//	Three2      int64 `json:"32"`
	//	Four        int64 `json:"4"`
	//	Eight       int64 `json:"8"`
	//	GreaterSix4 int64 `json:">=64"`
	//} `json:"iodepth_level"`
	//IodepthSubmit struct {
	//	Zero        int64 `json:"0"`
	//	One6        int64 `json:"16"`
	//	Three2      int64 `json:"32"`
	//	Four        int64 `json:"4"`
	//	Six4        int64 `json:"64"`
	//	Eight       int64 `json:"8"`
	//	GreaterSix4 int64 `json:">=64"`
	//} `json:"iodepth_submit"`
	//Job_options struct {
	//	Bs         string `json:"bs"`
	//	Direct     string `json:"direct"`
	//	Iodepth    string `json:"iodepth"`
	//	Ioengine   string `json:"ioengine"`
	//	RampTime   string `json:"ramp_time"`
	//	Randrepeat string `json:"randrepeat"`
	//	Runtime    string `json:"runtime"`
	//	Rw         string `json:"rw"`
	//	Stonewall  string `json:"stonewall"`
	//	TimeBased  string `json:"time_based"`
	//	Verify     string `json:"verify"`
	//} `json:"job options"`
	JobRuntime   int64  `json:"job_runtime"`
	Jobname      string `json:"jobname"`
	LatencyDepth int64  `json:"latency_depth"`
	//LatencyMs    struct {
	//	One0          int64   `json:"10"`
	//	One00         int64   `json:"100"`
	//	One000        int64   `json:"1000"`
	//	Two           float64 `json:"2"`
	//	Two0          int64   `json:"20"`
	//	Two000        int64   `json:"2000"`
	//	Two50         int64   `json:"250"`
	//	Four          float64 `json:"4"`
	//	Five0         int64   `json:"50"`
	//	Five00        int64   `json:"500"`
	//	Seven50       int64   `json:"750"`
	//	GreaterTwo000 int64   `json:">=2000"`
	//} `json:"latency_ms"`
	//LatencyNs struct {
	//	One0    int64 `json:"10"`
	//	One00   int64 `json:"100"`
	//	One000  int64 `json:"1000"`
	//	Two     int64 `json:"2"`
	//	Two0    int64 `json:"20"`
	//	Two50   int64 `json:"250"`
	//	Four    int64 `json:"4"`
	//	Five0   int64 `json:"50"`
	//	Five00  int64 `json:"500"`
	//	Seven50 int64 `json:"750"`
	//} `json:"latency_ns"`
	//LatencyPercentile int64 `json:"latency_percentile"`
	//LatencyTarget     int64 `json:"latency_target"`
	//LatencyUs         struct {
	//	One0    int64   `json:"10"`
	//	One00   float64 `json:"100"`
	//	One000  int64   `json:"1000"`
	//	Two     int64   `json:"2"`
	//	Two0    float64 `json:"20"`
	//	Two50   float64 `json:"250"`
	//	Four    int64   `json:"4"`
	//	Five0   float64 `json:"50"`
	//	Five00  float64 `json:"500"`
	//	Seven50 float64 `json:"750"`
	//} `json:"latency_us"`
	//LatencyWindow int64 `json:"latency_window"`
	//Majf          int64 `json:"majf"`
	//Minf          int64 `json:"minf"`
	Read struct {
		//Bw        int64   `json:"bw"`
		//BwAgg     float64   `json:"bw_agg"`
		//BwBytes   int64   `json:"bw_bytes"`
		//BwDev     float64 `json:"bw_dev"`
		//BwMax     int64   `json:"bw_max"`
		BwMean float64 `json:"bw_mean"`
		//BwMin     int64   `json:"bw_min"`
		//BwSamples int64   `json:"bw_samples"`
		//ClatNs    struct {
		//	N          int64   `json:"N"`
		//	Max        int64   `json:"max"`
		//	Mean       float64 `json:"mean"`
		//	Min        int64   `json:"min"`
		//	Percentile struct {
		//		One_000000    int64 `json:"1.000000"`
		//		One0_000000   int64 `json:"10.000000"`
		//		Two0_000000   int64 `json:"20.000000"`
		//		Three0_000000 int64 `json:"30.000000"`
		//		Four0_000000  int64 `json:"40.000000"`
		//		Five_000000   int64 `json:"5.000000"`
		//		Five0_000000  int64 `json:"50.000000"`
		//		Six0_000000   int64 `json:"60.000000"`
		//		Seven0_000000 int64 `json:"70.000000"`
		//		Eight0_000000 int64 `json:"80.000000"`
		//		Nine0_000000  int64 `json:"90.000000"`
		//		Nine5_000000  int64 `json:"95.000000"`
		//		Nine9_000000  int64 `json:"99.000000"`
		//		Nine9_500000  int64 `json:"99.500000"`
		//		Nine9_900000  int64 `json:"99.900000"`
		//		Nine9_950000  int64 `json:"99.950000"`
		//		Nine9_990000  int64 `json:"99.990000"`
		//	} `json:"percentile"`
		//	Stddev float64 `json:"stddev"`
		//} `json:"clat_ns"`
		//DropIos     int64   `json:"drop_ios"`
		//IoBytes     int64   `json:"io_bytes"`
		//IoKbytes    int64   `json:"io_kbytes"`
		//Iops        float64 `json:"iops"`
		//IopsMax     int64   `json:"iops_max"`
		IopsMean float64 `json:"iops_mean"`
		//IopsMin     int64   `json:"iops_min"`
		//IopsSamples int64   `json:"iops_samples"`
		//IopsStddev  float64 `json:"iops_stddev"`
		LatNs struct {
			//N      int64   `json:"N"`
			//Max    int64   `json:"max"`
			Mean float64 `json:"mean"`
			//Min    int64   `json:"min"`
			//Stddev float64 `json:"stddev"`
		} `json:"lat_ns"`
		//Runtime  int64 `json:"runtime"`
		//ShortIos int64 `json:"short_ios"`
		//SlatNs   struct {
		//	N      int64   `json:"N"`
		//	Max    int64   `json:"max"`
		//	Mean   float64 `json:"mean"`
		//	Min    int64   `json:"min"`
		//	Stddev float64 `json:"stddev"`
		//} `json:"slat_ns"`
		TotalIos int64 `json:"total_ios"`
	} `json:"read"`
	//Sync struct {
	//	LatNs struct {
	//		N      int64 `json:"N"`
	//		Max    int64 `json:"max"`
	//		Mean   int64 `json:"mean"`
	//		Min    int64 `json:"min"`
	//		Stddev int64 `json:"stddev"`
	//	} `json:"lat_ns"`
	//	TotalIos int64 `json:"total_ios"`
	//} `json:"sync"`
	//SysCPU float64 `json:"sys_cpu"`
	//Trim   struct {
	//	Bw        int64   `json:"bw"`
	//	BwAgg     float64 `json:"bw_agg"`
	//	BwBytes   int64   `json:"bw_bytes"`
	//	BwDev     int64   `json:"bw_dev"`
	//	BwMax     int64   `json:"bw_max"`
	//	BwMean    float64 `json:"bw_mean"`
	//	BwMin     int64   `json:"bw_min"`
	//	BwSamples int64   `json:"bw_samples"`
	//	ClatNs    struct {
	//		N      int64 `json:"N"`
	//		Max    int64 `json:"max"`
	//		Mean   int64 `json:"mean"`
	//		Min    int64 `json:"min"`
	//		Stddev int64 `json:"stddev"`
	//	} `json:"clat_ns"`
	//	DropIos     int64 `json:"drop_ios"`
	//	IoBytes     int64 `json:"io_bytes"`
	//	IoKbytes    int64 `json:"io_kbytes"`
	//	Iops        int64 `json:"iops"`
	//	IopsMax     int64 `json:"iops_max"`
	//	IopsMean    int64 `json:"iops_mean"`
	//	IopsMin     int64 `json:"iops_min"`
	//	IopsSamples int64 `json:"iops_samples"`
	//	IopsStddev  int64 `json:"iops_stddev"`
	//	LatNs       struct {
	//		N      int64 `json:"N"`
	//		Max    int64 `json:"max"`
	//		Mean   int64 `json:"mean"`
	//		Min    int64 `json:"min"`
	//		Stddev int64 `json:"stddev"`
	//	} `json:"lat_ns"`
	//	Runtime  int64 `json:"runtime"`
	//	ShortIos int64 `json:"short_ios"`
	//	SlatNs   struct {
	//		N      int64 `json:"N"`
	//		Max    int64 `json:"max"`
	//		Mean   int64 `json:"mean"`
	//		Min    int64 `json:"min"`
	//		Stddev int64 `json:"stddev"`
	//	} `json:"slat_ns"`
	//	TotalIos int64 `json:"total_ios"`
	//} `json:"trim"`
	//UsrCPU float64 `json:"usr_cpu"`
	Write struct {
		//Bw        int64   `json:"bw"`
		//BwAgg     float64 `json:"bw_agg"`
		//BwBytes   int64   `json:"bw_bytes"`
		//BwDev     float64 `json:"bw_dev"`
		//BwMax     int64   `json:"bw_max"`
		BwMean float64 `json:"bw_mean"`
		//BwMin     int64   `json:"bw_min"`
		//BwSamples int64   `json:"bw_samples"`
		//ClatNs    struct {
		//	N          int64 `json:"N"`
		//	Max        int64 `json:"max"`
		//	Mean       int64 `json:"mean"`
		//	Min        int64 `json:"min"`
		//	Percentile struct {
		//		One_000000    int64 `json:"1.000000"`
		//		One0_000000   int64 `json:"10.000000"`
		//		Two0_000000   int64 `json:"20.000000"`
		//		Three0_000000 int64 `json:"30.000000"`
		//		Four0_000000  int64 `json:"40.000000"`
		//		Five_000000   int64 `json:"5.000000"`
		//		Five0_000000  int64 `json:"50.000000"`
		//		Six0_000000   int64 `json:"60.000000"`
		//		Seven0_000000 int64 `json:"70.000000"`
		//		Eight0_000000 int64 `json:"80.000000"`
		//		Nine0_000000  int64 `json:"90.000000"`
		//		Nine5_000000  int64 `json:"95.000000"`
		//		Nine9_000000  int64 `json:"99.000000"`
		//		Nine9_500000  int64 `json:"99.500000"`
		//		Nine9_900000  int64 `json:"99.900000"`
		//		Nine9_950000  int64 `json:"99.950000"`
		//		Nine9_990000  int64 `json:"99.990000"`
		//	} `json:"percentile"`
		//	Stddev int64 `json:"stddev"`
		//} `json:"clat_ns"`
		//DropIos     int64 `json:"drop_ios"`
		//IoBytes     int64 `json:"io_bytes"`
		//IoKbytes    int64 `json:"io_kbytes"`
		//Iops        int64 `json:"iops"`
		//IopsMax     int64 `json:"iops_max"`
		IopsMean float64 `json:"iops_mean"`
		//IopsMin     int64 `json:"iops_min"`
		//IopsSamples int64 `json:"iops_samples"`
		//IopsStddev  int64 `json:"iops_stddev"`
		LatNs struct {
			//N      int64 `json:"N"`
			//Max    int64 `json:"max"`
			Mean float64 `json:"mean"`
			//Min    int64 `json:"min"`
			//Stddev int64 `json:"stddev"`
		} `json:"lat_ns"`
		//Runtime  int64 `json:"runtime"`
		//ShortIos int64 `json:"short_ios"`
		//SlatNs   struct {
		//	N      int64 `json:"N"`
		//	Max    int64 `json:"max"`
		//	Mean   int64 `json:"mean"`
		//	Min    int64 `json:"min"`
		//	Stddev int64 `json:"stddev"`
		//} `json:"slat_ns"`
		TotalIos int64 `json:"total_ios"`
	} `json:"write"`
}
