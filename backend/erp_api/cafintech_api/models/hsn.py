from django.db import models

class HSN(models.Model):
    cid = models.CharField(max_length=2, null=False)
    hsnCode = models.CharField(max_length=2,primary_key=True,null=False)
    hsnShortDescription = models.CharField(max_length=50,null=False)
    hsnDescription = models.CharField(max_length=500,null=False)
    isService=models.CharField(max_length=1,null=False)
    gstTaxRate=models.DecimalField(max_digits=5,decimal_places=2, null=False)

    class Meta:
        managed = False
        db_table = "[sales].[HSN]"