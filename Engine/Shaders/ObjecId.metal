//
//  ObjecId.metal
//  Engine
//
//  Created by Andrii on 16.05.2024.
//

#import "Common.h"

struct FragmentOut {
    uint objectId [[color(0)]];
};

fragment FragmentOut fragment_objectId(constant Params &params [[buffer(ParamsBuffer)]]) {
    FragmentOut out {
        .objectId = params.objectId
    };
    return out;
}


