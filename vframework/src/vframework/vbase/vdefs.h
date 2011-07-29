
#ifndef VDEFS_H_
#define VDEFS_H_

#define null(type) (type*)(NULL)

#define raw_name(name) name##_data

#define data_class(name) class raw_name(name)

#define ref_class(name) \
    class name##_data; typedef vref<name##_data> name

#define new_data(name) new raw_name(name)

#define STATIC_CLASS(type) \
  private: \
    type() {}

#define SINGLETON(type) \
  public: \
    static type* ref () { \
        static type *singleton = NULL; \
        return singleton ? singleton : (singleton = new type); \
    } \
  private: \
    type() {}

#define native_method(type, name, args, code) \
    type name args code

#define native_return(type, name, args, native_call) \
    native_method(type, name, args, { return native_call; })

#define native_args_return(type, name, args, call_args) \
    native_return(type, name, args, ::name call_args)

#define native_wrap_return(type, name) \
    native_return(type, name, (), ::name())

#define native_void(name, args, native_call) \
    native_method(void, name, args, { native_call; })

#define LIB_FUNC(type, name, args) \
    type name args


#endif /* VDEFS_H_ */
