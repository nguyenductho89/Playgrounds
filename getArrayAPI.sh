#!/bin/bash
helpFunction()
{
   echo ""
   echo "Usage: $0 -a apiName -e entityName -r reposName"
   echo "\t-a name of the api ex: GetMembersApi"
   echo "\t-e name of the entity ex: MemberDrEntity"
   echo "\t-r name of the repos ex: SelectDrJoinMeetingListRepos"
   exit 1 # Exit script after printing help
}

while getopts "a:e:r:" opt
do
   case "$opt" in
      a ) apiName="$OPTARG" ;;
      e ) entityName="$OPTARG" ;;
      r ) reposName="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$apiName" ] || [ -z "$entityName" ] || [ -z "$reposName" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi


# Begin script in case all parameters are correct
cat > $apiName.swift << EOF
//
//  $apiName.swift
//  Prjoy
//
//  Created by Nguyen Duc Tho on $(date +%D).
//  Copyright © 2020 Dr.JOY No,054. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class $apiName: API<Array<$entityName>> {

    private var param: String

    required init(param: String) {
        self.param = param
    }

    override func convertJson(_ val: Any) throws -> Array<$entityName> {
        var ret: Array<$entityName> = Array()
        if let dict = val as? Dictionary<String, AnyObject> {
            ret = try JSONDecoder().decode([$entityName].self, from: JSONSerialization.data(withJSONObject: dict["members"] as Any))
        }
        return ret
    }

    override func path() -> String {
        return "/pr/rc/office/members"
    }

    override func method() -> Alamofire.HTTPMethod {
        return .get
    }

    override func baseUrl() -> String {
        //TODO: Remove this
        return Const.AT_BASE_API_URL
    }

    override func params() -> Parameters {
        return ["param":self.param]
    }
}

EOF


cat > $reposName.swift << EOF
//
//  $reposName.swift
//  Prjoy
//
//  Created by Nguyen Duc Tho on $(date +%D).
//  Copyright © 2019 Dr.JOY No,054. All rights reserved.
//

import Foundation
import RxSwift

protocol $reposName {
    func getArray(param: String) -> Observable<Array<$entityName>>
}
EOF

cat > ${reposName}Impl.swift << EOF
//
//  ${reposName}Imp.swift
//  Prjoy
//
//  Created by Nguyen Duc Tho on $(date +%D).
//  Copyright © 2019 Dr.JOY No,054. All rights reserved.
//

import Foundation
import RxSwift

class ${reposName}Imp: $reposName {
    func getArray(param: String) -> Observable<Array<$entityName>> {
        return $apiName(param:param).request()
    }
}
EOF
