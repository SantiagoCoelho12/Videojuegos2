package paths;

import kha.math.FastVector2;

interface Path {
    function getPos(s:Float):FastVector2;
    function getLength():Float;
}