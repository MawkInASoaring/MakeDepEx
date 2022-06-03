TARGETS = main1 main2
INCDIR1 = .
OBJDIR = obj
CPPINCFILES1 = $(wildcard $(INCDIR1)/*.h)
CC=gcc

all: $(TARGETS)

# Target object files
SRCDIR = .
SRC = $(wildcard $(SRCDIR)/*.c)
OBJ := $(addprefix $(OBJDIR)/,$(notdir $(SRC:.c=.o)))

#options
GPPOPT = -O0 -Wall

#options
DEBUG = -g
LISTFILE_CPP = -Wa,-aghl=$(OBJDIR)/$(basename $<).lst -save-temps=$(OBJDIR)

# Create directory for object and temp files
MKOBJDIR := $(shell mkdir -p $(OBJDIR))

#Auto Build rules : brutally rebuild all issue.
$(TARGETS): %: $(OBJDIR)/%.o $(OBJDIR)/%.adep $(OBJ)
	@set -e;
#	echo "linking";
	$(CC) $< $(shell cat $(OBJDIR)/*.adep | awk '!/$*.o/ || seen { print } /$*.o/ && !seen { seen = 1 }') -o $@

# Note:

MAKEDEPEND = $(CC) -MM $< | grep -oh "\w*\.h"  | sed 's,\([ ]*\)\.h,\1.c ,g'  | grep -oh "\w*\.c"  \
			| xargs -I% find . -type f -maxdepth 1 -name "%" |  sed 's|^./||' | sed 's,\([ ]*\)\.c,\1.o ,g' | sed 's/^/obj\//' > $@ 
				
#
	
$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@set -e; \
	echo "compile obj" $@	
	$(CC) $(DEBUG) $(LISTFILE_CPP) $(GPPOPT) -I$(INCDIR1) -c $< -o $@
				
$(OBJDIR)/%.adep: $(SRCDIR)/%.c
	@set -e; \
	rm -f $@; \
	echo "hello dep"
	@$(MAKEDEPEND)
	cat $(@)


.PHONY: all	clean

clean:
	rm -f $(SRCDIR)/*.d* $(SRCDIR)/*.o
	rm -f $(TARGETS)
	rm -rf $(OBJDIR)
