	for(int i=0;i<(IMAGE_SIZE/2);i++)
{
	char a,b,c;
	a=data[i];
	b=data[i+1];
	c=data[i+2];
	for(int j=IMAGE_SIZE/2;j>0;j--)
	data[i]=data[(IMAGE_SIZE)-(i+2)];
	data[i+1]=data[(IMAGE_SIZE)-(i+1)];
	data[i+2]=data[(IMAGE_SIZE)-(i)];	
	
	data[(IMAGE_SIZE)-(i+2)]=a;
	data[(IMAGE_SIZE)-(i+1)]=b;
	data[(IMAGE_SIZE)-(i)]=c;
	i=i+2;
}
  FILE *f = fopen ("obrot.bmp", "wb");
  char *data2;
 data2 =obrot(data,IMAGE_SIZE/8);
 fwrite(header,1,nread2,f);
  fseek(f,14+HEADER_SIZE,0);
  fwrite(data2,1,nread,f);
  fclose(f);
