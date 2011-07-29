/*
 * vobject.h
 *
 *  Created on: Aug 1, 2010
 *      Author: kazuo
 */

#ifndef VOBJECT_H_
#define VOBJECT_H_

#include <vframework/vbase/vdefs.h>
#include <vframework/vbase/vref.h>

namespace vframework {
namespace vbase {

#define VOBJECT raw_name(vobject)

ref_class(vobject);

data_class(vobject) {
public:
    VOBJECT () {
        // TODO Auto-generated constructor stub

    }
    virtual ~VOBJECT () {
        // TODO Auto-generated destructor stub
    }
    void that();
    void those();
};

}
}

#endif /* VOBJECT_H_ */
