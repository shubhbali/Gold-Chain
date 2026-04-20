package gilt

type (
	GiltApiClient              = BorApiClient
	GiltApiServer              = BorApiServer
	UnimplementedGiltApiServer = UnimplementedBorApiServer
	UnsafeGiltApiServer        = UnsafeBorApiServer
)

var NewGiltApiClient = NewBorApiClient
var RegisterGiltApiServer = RegisterBorApiServer
