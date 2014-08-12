//
//  TNTXCTTestMacros.h
//  NitroMisc
//
//  Created by Daniel L. Alves on 7/8/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#ifndef TNT_XCTTEST_MACROS_H
#define TNT_XCTTEST_MACROS_H

#define XCTFailIfParameterNil(parameter) if( parameter == nil ){ XCTFail(@"Invalid parameter: %s must not be nil", #parameter); }

#endif
