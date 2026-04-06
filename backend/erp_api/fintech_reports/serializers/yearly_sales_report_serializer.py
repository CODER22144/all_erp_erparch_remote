from rest_framework import serializers

class YearlySalesReportSerializer(serializers.Serializer):
    fromDate = serializers.CharField(max_length=20)
    toDate = serializers.CharField(max_length=20)

