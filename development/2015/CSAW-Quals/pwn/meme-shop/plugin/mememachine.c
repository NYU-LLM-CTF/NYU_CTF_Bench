// Include the Ruby headers and goodies
#include "ruby.h"

typedef int (*checkit)(int good);

typedef  struct _skeletal {
	char str[256]; // to store the resut
	int beep2;
	checkit opt; // funtion pointer
	int good;
} SKELETAL;

typedef  struct _othermeme {
	int beep;
	checkit opt; // funtion pointer
	int good;
} MEME;

int yessir(void* ya) {
	return 1;
}

size_t memerz[256];
size_t types[256];

// Defining a space for information and references about the module to be stored internally
VALUE MemeMachine = Qnil;

// Ruby calls this, not you
void Init_mememachine();

// methods are prefixed by 'method_' here
VALUE method_addmeme(VALUE self);
VALUE method_addskeletal(VALUE self, VALUE rbstr);
VALUE method_checkout(VALUE self, VALUE rbint);

int gooder(int value) {
	return !!value;
}

int badder(int value) {
	return !value;
}

uint8_t counter = 0;
int types_tracker = 0;

// The initialization method for this module
void Init_mememachine() {
	MemeMachine = rb_define_module("MemeMachine");
	rb_define_method(MemeMachine, "addmeme", method_addmeme, 0);
	rb_define_method(MemeMachine, "addskeletal", method_addskeletal, 1);
	rb_define_method(MemeMachine, "checkout", method_checkout, 1);
}

VALUE method_addmeme(VALUE self) {
	MEME* mynewmeme = malloc(sizeof(MEME));
	mynewmeme->opt = gooder;
	mynewmeme->good = 0;
	memerz[counter] = (size_t)mynewmeme;
	types[types_tracker] = 0;
	types_tracker++;
	counter++;
	return rb_str_new2("meme successfully added");
}

VALUE method_addskeletal(VALUE self, VALUE rbstr) {
	char* c_mystring = RSTRING_PTR(rbstr);
	SKELETAL* mynewmeme = malloc(sizeof(SKELETAL));
	memcpy(mynewmeme->str, c_mystring, 128);
	mynewmeme->opt = gooder;
	if (!strcmp("thanks mr skeletal", mynewmeme->str)) {
		mynewmeme->good = 0;
		memerz[counter] = (size_t)mynewmeme;
		types[types_tracker] = 1;
		types_tracker++;
		memerz[counter] = (size_t)mynewmeme;
		counter++;
		return rb_str_new2("meme successfully added");
	} else {
		mynewmeme->good = 0;
		types[types_tracker] = 1;
		types_tracker++;
		memerz[counter] = (size_t)mynewmeme;
		mynewmeme->opt = badder;
		counter++;
		return rb_str_new2("im going to steal all ur calcuims");
	}
}

VALUE method_checkout(VALUE self, VALUE rbint) {
	int c_myint = FIX2INT(rbint);
	int i;
	int ret = 0;
	for (i = 0; i < c_myint; ++i) {
		void* memerino = (void*) memerz[i];
		int type = types[i];
		if (type == 0) {
			ret |= ((MEME*)memerino)->opt(((MEME*)memerino)->good);
		} else {
			ret |= ((SKELETAL*)memerino)->opt(((SKELETAL*)memerino)->good);
		}
	}
	if (ret == 0) {
		return rb_str_new2("successfully checked out");
	} else {
		return rb_str_new2("you are going to get memed on so hard with no calcium");
	}
}
