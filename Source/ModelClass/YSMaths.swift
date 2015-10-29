//
//  YSMaths.swift
//  NoFear
//
//  Created by Gururaj Tallur on 23/04/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class YSMaths: NSObject {

    var input_1: Int = 0
    var input_2: Int = 0
    var result_num : Int = 0
    var result_Digit_Count : Int = 0
    var subLevel : Int = 0
    var currentOp : Operators!
    var parentScene : YSGameScene!
    
    func initWithScene(inScene :YSGameScene)
    {
        self.parentScene = inScene;
        
        self.subLevel = 0;
        self.result_Digit_Count = 1;
    }

    
    
    /*
    LEVEL 1: +, 1 to 5
    LEVEL 2: +, 1 to 9
    LEVEL 3: +, 6 to 9
    LEVEL 4: -, 1 to 5
    LEVEL 5: -, 1 to 9
    */

    
    
    
    func setupOperatorMaths()
    {
        self.subLevel++
        
        if(self.subLevel>5)
        {
            self.subLevel = 1;
            YSGameManager.sharedGameManager.currentLevel++;
            
            self.parentScene.showLevelUp();
        }
        
        switch (YSGameManager.sharedGameManager.currentLevel)
        {
            case 1:
                self.input_1 = 1 + Int(arc4random_uniform(5)) ;
                self.input_2 = 1 + Int(arc4random_uniform(4)) ;
                self.currentOp = Operators.kOperator_Plus;
                self.result_num = self.input_1 + self.input_2;
            break;
            case 2:
                self.input_1 = 1 + Int(arc4random_uniform(9)) ;
                self.input_2 = 1 + Int(arc4random_uniform(9)) ;
                self.currentOp = Operators.kOperator_Plus;
                self.result_num = self.input_1 + self.input_2;
            break;
        
            case 3:
                self.input_1 = 1 + Int(arc4random_uniform(9)) ;
                self.input_2 = 1 + Int(arc4random_uniform(9)) ;
                
                if(self.input_1 < self.input_2 )
                {
                    let temp = self.input_1 as Int;
                    self.input_1 = self.input_2 ;
                    self.input_2 = temp;
                }
                
                self.currentOp = Operators.kOperator_Minus;
                self.result_num = self.input_1 - self.input_2;
            break;
        case 4:
            self.input_1 = 5 + Int(arc4random_uniform(5)) ;
            self.input_2 = 5 + Int(arc4random_uniform(5)) ;
            
            if(self.input_1 < self.input_2 )
            {
                let temp = self.input_1 as Int;
                self.input_1 = self.input_2 ;
                self.input_2 = temp;
            }
            
            self.currentOp = Operators.kOperator_Minus;
            self.result_num = self.input_1 - self.input_2;
            break;
        case 5:
            if(Int(arc4random_uniform(2)) == 0)
            {
            self.input_1 = 10 + Int(arc4random_uniform(5)) ;
            self.input_2 = 13 + Int(arc4random_uniform(4)) ;
            self.currentOp = Operators.kOperator_Plus;
            self.result_num = self.input_1 + self.input_2;
            }
            else
            {
            self.input_1 = 5 + Int(arc4random_uniform(5)) ;
            self.input_2 = 5 + Int(arc4random_uniform(5)) ;
            
            if(self.input_1 < self.input_2 )
            {
                let temp = self.input_1 as Int;
                self.input_1 = self.input_2 ;
                self.input_2 = temp;
            }
            
            self.currentOp = Operators.kOperator_Minus;
            self.result_num = self.input_1 - self.input_2;
            }
            break;
        case 6:
            self.input_1 = 1 + Int(arc4random_uniform(4)) ;
            self.input_2 = 1 + Int(arc4random_uniform(5)) ;
            
            self.currentOp = Operators.kOperator_Multiplication;
            self.result_num = self.input_1 * self.input_2;
            break;
        case 7:
            if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
            {
                self.input_1 = 5 + Int(arc4random_uniform(3)) ;
                self.input_2 = 5 + Int(arc4random_uniform(3)) ;
                
                self.currentOp = Operators.kOperator_Multiplication;
                self.result_num = self.input_1 * self.input_2;
                }
                else
                {
                self.input_1 = 5 + Int(arc4random_uniform(5)) ;
                self.input_2 = 5 + Int(arc4random_uniform(5)) ;
                
                self.currentOp = Operators.kOperator_Multiplication;
                self.result_num = self.input_1 * self.input_2;
            }
            break;
        case 8:
            if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
            {
                self.input_1 = 1 + Int(arc4random_uniform(5)) ;
                self.input_2 = 1 + Int(arc4random_uniform(4)) ;
                self.currentOp = Operators.kOperator_Plus;
                self.result_num = self.input_1 + self.input_2;
            }
            else
            {
                if(Int(arc4random_uniform(2))==0)
                {
                self.input_1 = (Int(arc4random_uniform(2))==0) ? 8 : 4;
                self.input_2 = (Int(arc4random_uniform(2))==0) ? 4 : 2;
                }
                else
                {
                self.input_1 = (Int(arc4random_uniform(2))==0) ? 9 : 6;
                self.input_2 = (Int(arc4random_uniform(2))==0) ? 3 : 1;
                }
                
                self.currentOp = Operators.kOperator_Division;
                self.result_num = self.input_1 / self.input_2;
            }
            break;
        case 9:
            if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
            {
                self.input_1 = 1 + Int(arc4random_uniform(8)) ;
                self.input_2 = 1 + Int(arc4random_uniform(2)) ;
                self.currentOp = Operators.kOperator_Plus;
                self.result_num = self.input_1 + self.input_2;
            }
            else
            {
                let rand_1 = 1 + Int(arc4random_uniform(5)) as Int;
                let rand_mul = 1 + Int(arc4random_uniform(5)) as Int;
                
                self.input_1 = rand_1 * rand_mul;
                self.input_2 = rand_mul;
                
                self.currentOp = Operators.kOperator_Division;
                self.result_num = self.input_1 / self.input_2;
            }
            
            break;
        case 10:
            if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
            {
                self.input_1 = 1 + Int(arc4random_uniform(3)) ;
                self.input_2 = 1 + Int(arc4random_uniform(5)) ;
                self.currentOp = Operators.kOperator_Plus;
                self.result_num = self.input_1 + self.input_2;
            }
            else
            {
                let rand_1 = 1 + Int(arc4random_uniform(9)) as Int;
                let rand_mul = 1 + Int(arc4random_uniform(9)) as Int;
                
                self.input_1 = rand_1 * rand_mul;
                self.input_2 = rand_mul;
                
                self.currentOp = Operators.kOperator_Division;
                self.result_num = self.input_1 / self.input_2;
            }
            break;
        
        default:
        switch (self.subLevel)
        {
            case 1:
            if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
            {
                self.input_1 = 1 + Int(arc4random_uniform(6)) ;
                self.input_2 = 1 + Int(arc4random_uniform(4)) ;
                self.currentOp = Operators.kOperator_Plus;
                self.result_num = self.input_1 + self.input_2;
            }
            else
            {
                self.input_1 = 1 + Int(arc4random_uniform(25)) ;
                self.input_2 = 1 + Int(arc4random_uniform(25)) ;
                self.currentOp = Operators.kOperator_Plus;
                self.result_num = self.input_1 + self.input_2;
            }
        break;
        case 2:
            if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
            {
                self.input_1 = 1 + Int(arc4random_uniform(4)) ;
                self.input_2 = 5 + Int(arc4random_uniform(5)) ;
                
                if(self.input_1 < self.input_2 )
                {
                    let temp = self.input_1 as Int;
                    self.input_1 = self.input_2 ;
                    self.input_2 = temp;
                }
                
                self.currentOp = Operators.kOperator_Minus;
                self.result_num = self.input_1 - self.input_2;
            }
            else
            {
                self.input_1 = 1 + Int(arc4random_uniform(44)) ;
                self.input_2 = 5 + Int(arc4random_uniform(40)) ;
                
                if(self.input_1 < self.input_2 )
                {
                    let temp = self.input_1 as Int;
                    self.input_1 = self.input_2 ;
                    self.input_2 = temp;
                }
                
                self.currentOp = Operators.kOperator_Minus;
                self.result_num = self.input_1 - self.input_2;
            }
        break;
        case 3:
            if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
            {
                self.input_1 = 1 + Int(arc4random_uniform(6)) ;
                self.input_2 = 1 + Int(arc4random_uniform(3)) ;
                self.currentOp = Operators.kOperator_Plus;
                self.result_num = self.input_1 + self.input_2;
            }
            else
            {
                self.input_1 = 1 + Int(arc4random_uniform(45)) ;
                self.input_2 = 1 + Int(arc4random_uniform(45)) ;
                self.currentOp = Operators.kOperator_Plus;
                self.result_num = self.input_1 + self.input_2;
            }
            break;
        case 4:
            if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
            {
                self.input_1 = 1 + Int(arc4random_uniform(5)) ;
                self.input_2 = 1 + Int(arc4random_uniform(5)) ;
                self.currentOp = Operators.kOperator_Plus;
                self.result_num = self.input_1 + self.input_2;
            }
            else
            {
                self.input_1 = 1 + Int(arc4random_uniform(45)) ;
                self.input_2 = 1 + Int(arc4random_uniform(45)) ;
                self.currentOp = Operators.kOperator_Plus;
                self.result_num = self.input_1 + self.input_2;
            }
        break;
        
        default:
            if(YSGameManager.sharedGameManager.gGameMode == Game_Mode.kGameMode_KidsMode)
            {
                self.input_1 = 1 + Int(arc4random_uniform(5)) ;
                self.input_2 = 1 + Int(arc4random_uniform(4)) ;
                self.currentOp = Operators.kOperator_Plus;
                self.result_num = self.input_1 + self.input_2;
            }
            else
            {
                let rand_1 = 1 + Int(arc4random_uniform(9)) as Int;
                let rand_mul = 1 + Int(arc4random_uniform(9)) as Int;
                
                self.input_1 = rand_1 * rand_mul;
                self.input_2 = rand_mul;
                
                self.currentOp = Operators.kOperator_Division;
                self.result_num = self.input_1 / self.input_2;
            }
            break;
        }
        break;
    }
        
    self.result_Digit_Count = self.getNumDigit();
    
}

    func getNumDigit()->Int
    {
        if(self.result_num == 0)
        {
            return 1;
        }
        
        var count: Int = 0
       
        var n = self.result_num as Int;
        
        while(!(n==0))
        {
            n/=10;
            ++count;
        }
    return count;
    }

}
