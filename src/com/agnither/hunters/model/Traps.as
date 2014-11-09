/**
 * Created by mor on 08.11.2014.
 */
package com.agnither.hunters.model
{
import com.agnither.hunters.data.outer.TrapVO;
import com.agnither.hunters.model.Model;

public class Traps
{
    private var traps : Array;
    public function Traps()
    {
    }

    public function addTrap($trap : TrapVO) : void
    {
        Model.instance.progress.traps.push($trap);
    }
}
}
