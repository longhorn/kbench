package types

const (
	VolumeAccessModeRWO = "rwo"
	VolumeAccessModeRWX = "rwx"

	TestModeReadOnly  = "read-only"
	TestModeWriteOnly = "write-only"
	TestModeReadWrite = "read-write"

	RateLimitTypeRateLimit   = "rate-limit"
	RateLimitTypeNoRateLimit = "no-rate-limit"

	IOPatternRandom     = "random"
	IOPatternSequential = "sequential"

	IOTypeRead  = "read"
	IOTypeWrite = "write"
)
