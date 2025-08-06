{ lib, ... }:
{
  mkSectionList = list:
    let
      foldedAttr = lib.lists.foldl'
        (self: current: {
          _count = self._count + 1;
          final = self.final // { "${builtins.toString self._count}" = current; };
        })
        {
          _count = 0;
          final = { };
        }
        list;
    in
    foldedAttr.final;
}
