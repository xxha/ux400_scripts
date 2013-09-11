#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>


#define	UX400_PATH	"/sys/bus/usb/devices"

#define	UX400_LA_PATH	"/1-1.2"
#define	UX400_LB_PATH	"/1-1.3"
#define	UX400_LC_PATH	"/1-1.4"
#define	UX400_RA_PATH	"/1-5"
#define	UX400_RB_PATH	"/1-3"
#define	UX400_RC_PATH	"/1-1.1"


#define	BUF_SIZE	256

#define	MAX_NET_DEVICE	32

int main(int argc,char *argv[])
{
	char temp[BUF_SIZE];
	char tmp[BUF_SIZE];
	char npath0[BUF_SIZE];
	char npath1[BUF_SIZE];
	char npath[BUF_SIZE];
	
	int i = 0;

	if(argc < 2){
		printf("Usage: ./mdevcheck slot\n");
		exit(0);
	}

	system("/sbin/ux400cset");

	temp[0] = '\0';
	
	if( strcmp(argv[1], "LA") == 0){
		strcat(temp, UX400_LA_PATH);
	}else if( strcmp(argv[1], "LB") == 0){
		strcat(temp, UX400_LB_PATH);
	}else if( strcmp(argv[1], "LC") == 0){
		strcat(temp, UX400_LC_PATH);
	}else if( strcmp(argv[1], "RA") == 0){
		strcat(temp, UX400_RA_PATH);
	}else if( strcmp(argv[1], "RB") == 0){
		strcat(temp, UX400_RB_PATH);
	}else if( strcmp(argv[1], "RC") == 0){
		strcat(temp, UX400_RC_PATH);
	}else{
		printf("Unknow slot, please make sure you enter LA/LB/LC/RA/RB/RC\n");
		exit(0);
	}

	memset(npath0, '\0', BUF_SIZE);
	memset(npath1, '\0', BUF_SIZE);
	
	strcpy(npath0, UX400_PATH);
	strcat(npath0, temp);
	strcat(npath0, ":1.0/net");

	strcpy(npath1, UX400_PATH);
	strcat(npath1, temp);
	strcat(npath1, ":1.1/net");
	
	if(access(npath0, F_OK) != 0){
		if(access(npath1, F_OK) != 0){
			printf("Can't find the board at slot: %s\n", argv[1]);
			exit(0);
		}else{
			strcat(npath, npath1);
		}
	}else{
		strcat(npath, npath0);
	}

	for(i = 0; i < MAX_NET_DEVICE; i ++){
		temp[0] = '\0';
		strcat(temp, npath);
		sprintf(tmp, "/usb%d", i);
		strcat(temp, tmp);
		
		if(access(temp+1, F_OK) == 0){
			printf("The device name in slot: %s is: usb%d\n", argv[1], i);
			exit(i+1);
		}
	}

	exit(0);
}



