from rest_framework import serializers

class JobWorkOutSerializer(serializers.Serializer):
    bpCode = serializers.CharField(max_length=10)
    jpId = serializers.CharField(max_length=2)
    goodsType = serializers.CharField(max_length=1)
    reqId = serializers.IntegerField(required=False, allow_null=True)
    matnoReturn = serializers.CharField(max_length=15)
    qty = serializers.IntegerField()
    transMode = serializers.CharField(required=False, allow_null=True, max_length=1)
    carId = serializers.IntegerField(required=False, allow_null=True)
    grNo = serializers.CharField(required=False, allow_null=True, max_length=25)
    grDate = serializers.CharField(required=False, allow_null=True, max_length=30)
    vehicleNo = serializers.CharField(required=False, allow_null=True, max_length=15)
    ewbno = serializers.CharField(required=False, allow_null=True, max_length=15)

class JobWorkOutClearSerializer(serializers.Serializer):
    dt = serializers.CharField(max_length=20)
    docno = serializers.IntegerField()
    grno = serializers.IntegerField(allow_null=True, required=False)
    billNo = serializers.CharField(max_length=16, allow_null=True, required=False)
    billDate = serializers.CharField(max_length=20, allow_null=True, required=False)
    matno = serializers.CharField(max_length=15)
    qty = serializers.DecimalField(max_digits=12, decimal_places=3)
    rate = serializers.DecimalField(max_digits=12, decimal_places=3)

class JobWorkOutClearReportSerializer(serializers.Serializer):
    clId = serializers.IntegerField(allow_null=True, required=False)
    docno = serializers.IntegerField(allow_null=True, required=False)
    matno = serializers.CharField(max_length=15, allow_null=True, required=False)
    fromDate = serializers.CharField(max_length=20, allow_null=True, required=False)
    toDate = serializers.CharField(max_length=20, allow_null=True, required=False)

class JobWorkOutClearPendingSerializer(serializers.Serializer):
    docno = serializers.IntegerField(allow_null=True, required=False)
    bpCode = serializers.CharField(max_length=10, allow_null=True, required=False)
    fDate = serializers.CharField(max_length=20, allow_null=True, required=False)
    tDate = serializers.CharField(max_length=20, allow_null=True, required=False)
    type = serializers.CharField(max_length=1, allow_null=True, required=False)