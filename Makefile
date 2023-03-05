TARGET = fft_test
ARCH = 32



SRCDIR = src
OBJDIR = obj
BINDIR = bin

ifeq ($(ARCH),x86) 
CC = gcc
SRCS_c = $(SRCDIR)/fft_test.c $(SRCDIR)/NE10_fft.c $(SRCDIR)/NE10_fft_float32.c $(SRCDIR)/NE10_fft_generic_float32.c
else ifeq ($(ARCH),64) 
CC = /home/ryuk/project/toolchain/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-gcc
SRCS_c = $(SRCDIR)/fft_test.c $(SRCDIR)/NE10_fft.c $(SRCDIR)/NE10_rfft_float32.c $(SRCDIR)/NE10_rfft_float32.neonintrinsic.c $(SRCDIR)/NE10_fft_generic_float32.c
else
CC = /home/ryuk/project/toolchain/gcc-arm-11.2-2022.02-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-gcc
SRCS_c = $(SRCDIR)/fft_test.c $(SRCDIR)/NE10_fft.c $(SRCDIR)/NE10_fft_float32.c $(SRCDIR)/NE10_fft_float32.neon.c $(SRCDIR)/NE10_fft_float32.neonintrinsic.c $(SRCDIR)/NE10_fft_generic_float32.c
CFLAGS = -mfpu=neon
endif


OBJS = $(SRCS_c:$(SRCDIR)/%.c=$(OBJDIR)/%_c.o) 
rm = rm -f

CFLAGS += -Wall -g -O3 -lm -std=gnu11 


$(BINDIR)/$(TARGET): $(OBJS)
	$(CC) $(OBJS) $(CFLAGS) -o $@

$(OBJDIR)/%_c.o : $(SRCDIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@
	
$(OBJDIR)/%_cpp.o : $(SRCDIR)/%.cpp
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/%_S.o : $(SRCDIR)/%.s
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	$(rm) $(OBJS)

.PHONY: remove
remove:
	$(rm) $(BINDIR)/$(TARGET)
	
