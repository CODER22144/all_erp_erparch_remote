from rest_framework import serializers

class MaterialIncomingStandardSerializer(serializers.Serializer):
    matno = serializers.CharField(max_length=15)
    misSno = serializers.IntegerField()
    testType = serializers.CharField(max_length=30)
    isnpItem = serializers.CharField(max_length=30)
    instName = serializers.CharField(max_length=20, allow_null=True, required=False)
    lLimit = serializers.CharField(max_length=40)
    hLimit = serializers.CharField(max_length=40)
    sLimit = serializers.CharField(max_length=20)

class MaterialIncomingStandardReportSerializer(serializers.Serializer):
    fmatno = serializers.CharField(max_length=15)
    tmatno = serializers.CharField(max_length=15)

class ReadingSerializer(serializers.Serializer):
    misId = serializers.IntegerField()
    grdId = serializers.IntegerField()
    misSno = serializers.IntegerField()
    r1 = serializers.CharField(max_length=20)
    r2 = serializers.CharField(max_length=20, allow_null=True, required=False)
    r3 = serializers.CharField(max_length=20, allow_null=True, required=False)
    r4 = serializers.CharField(max_length=20, allow_null=True, required=False)
    r5 = serializers.CharField(max_length=20, allow_null=True, required=False)
    r6 = serializers.CharField(max_length=20, allow_null=True, required=False)
    r7 = serializers.CharField(max_length=20, allow_null=True, required=False)
    r8 = serializers.CharField(max_length=20, allow_null=True, required=False)
    r9 = serializers.CharField(max_length=20, allow_null=True, required=False)
    r10 = serializers.CharField(max_length=20, allow_null=True, required=False)

class IncomingReadingStandardSerializer(serializers.Serializer):
    grdId = serializers.IntegerField()
    tdate = serializers.CharField(max_length=20)
    sSize = serializers.IntegerField()
    ps = serializers.IntegerField()
    defect = serializers.CharField(max_length=40, allow_null=True, required=False)
    problem = serializers.CharField(max_length=100, allow_null=True, required=False)
    suggestion = serializers.CharField(max_length=100, allow_null=True, required=False)
    remark = serializers.CharField(max_length=100)
    userId = serializers.CharField(max_length=50) 
    Reading = ReadingSerializer(many=True)

class IncomingReadingReportSerializer(serializers.Serializer):
    fdate = serializers.CharField(max_length=20)
    tdate = serializers.CharField(max_length=20)
    fmatno = serializers.CharField(max_length=15, allow_null=True, required=False)
    tmatno = serializers.CharField(max_length=15, allow_null=True, required=False)
    grno = serializers.CharField(max_length=20, allow_null=True, required=False) 