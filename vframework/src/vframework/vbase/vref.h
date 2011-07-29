/*
 * vref.h
 *
 * Object memory management system. TODO comment
 *
 *  Created on: Aug 1, 2010
 *      Author: kazuo
 */

#ifndef VREF_H_
#define VREF_H_

#include <memory>
#include <vframework/vbase/vtypes.h>
#include <vframework/vbase/vdefs.h>

namespace vframework {
namespace vbase {

// Forward declaration of the vobject data_class;
// Every data_class MUST inherit, be it directly or indirectly, from the
// vobject data_class.
data_class(vobject);

// Base class for internal reference management.
template <class base_type = raw_name(vobject), class alloc_type = std::allocator<base_type> >
class internal_ref_base {

  public:

    // Destructor.
    virtual ~internal_ref_base () {}

    // Reference count.
    v_size      count;

  protected:

    // Constructor.
    internal_ref_base () : count(0), data_(NULL) {}

    // Internal reference to the data_class object.
    base_type   *data_;

}; // class internal_ref_base.

// Template class which represents the ref_class's.
template
    <class type, class base_type = raw_name(vobject), class alloc_type = std::allocator<base_type> >
class vref {

  public:

    typedef internal_ref_base<base_type, alloc_type> internal_ref_base_type;

  protected:

    // Internal type-specific reference management class.
    class internal_ref : public internal_ref_base_type {

      public:

        // Constructor. It's ok to store the value received in data_ because
        // it's class should inherit from vobject data_class.
        internal_ref (type *data) : ownership_(true) {
            this->data_ = data;
        }

        // Destructor. Guarantees that the memory is freed.
        ~internal_ref () {
            type *data = get();
            if (ownership_ && data) {
                alloc_type alloc;
                alloc.destroy(data);
                alloc.deallocate(data, 1);
            }
        }

        // Reference access. Casts to the expected type.
        type *get () {
            return static_cast<type*>(this->data_);
        }

        v_void set_ownership (v_bool ownership) {
            this->ownership_ = ownership;
        }

      private:

        v_bool  ownership_;

    };

  public:

    vref (const vref& ref) : iref_(NULL) {
        reset(ref);
    }

    template <typename derived>
    vref (const vref<derived>& ref) : iref_(NULL) {
        reset(ref);
    }

    template <typename derived>
    vref (derived *obj) : iref_(NULL) {
        reset(obj);
    }

    vref (type *obj = NULL) : iref_(NULL) {
        reset(obj);
    }

    virtual ~vref () {
        removeRef();
    }

    template <class derived>
    vref& reset (derived *obj) {
        return reset(obj ? new internal_ref(obj) : NULL);
    }

    vref& reset (internal_ref *iref) {
        return internalReset(iref);
    }

    template <class derived>
    vref& reset (const vref<derived>& ref) {
        return internalReset(ref.iref());
    }

    vref& reset (const vref& ref) {
       return internalReset(ref.iref());
    }

    internal_ref *iref () const {
        return iref_;
    }

    template <class derived>
    vref& operator = (const vref<derived>& ref) {
        return reset<derived>(ref);
    }

    vref& operator = (const vref& ref) {
        return reset(ref);
    }

    template <class derived>
    vref& operator = (derived *obj) {
        return reset(obj);
    }

    type* operator * () {
        return iref_->get();
    }

    type const* operator * () const {
        return iref_->get();
    }

    type* operator ->() {
        return iref_->get();
    }

    const type* operator -> () const {
        return iref_->get();
    }

    v_bool operator == (vref &ref) const {
        return *(*this) == (*ref);
    }

    v_bool operator == (type *ptr) const {
        return *(*this) == ptr;
    }

  protected:

    internal_ref *iref_;

    vref& internalReset (internal_ref_base_type *iref) {
        removeRef();
        addRef(static_cast<internal_ref*>(iref));
        return *this;
    }

    // Used when this vref object starts referencing some data.
    void addRef(internal_ref *iref) {
        iref_ = iref;
        if(iref_)
            iref_->count++;
    }

    // Used when this vref object stops referencing some data.
    void removeRef() {
        if (iref_ && --(iref_->count) <= 0) {
            delete iref_;
        }
        iref_ = NULL;
    }

};

}
}


#endif /* VREF_H_ */
