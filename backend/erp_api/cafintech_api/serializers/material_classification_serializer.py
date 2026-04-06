from rest_framework import serializers

class MaterialClassificationSerializer(serializers.Serializer):
    matno = serializers.CharField(max_length=15)
    brandId = serializers.IntegerField()
    DepartmentId = serializers.IntegerField()
    psid = serializers.CharField(max_length=2)
    categoryId = serializers.IntegerField()
    subCategoryId = serializers.IntegerField()
    pgId = serializers.IntegerField(allow_null=True, required=False)

class MaterialClassificationReportSerializer(serializers.Serializer):
    fmatno = serializers.CharField(max_length=15,allow_null=True, required=False)
    tmatno = serializers.CharField(max_length=15,allow_null=True, required=False)
    categoryId = serializers.IntegerField(allow_null=True, required=False)
    subCategoryId = serializers.IntegerField(allow_null=True, required=False)
