module SliceShow.Protected (Protected, unlock, lock) where


type Protected a = Locked a


unlock : Protected a -> a
unlock (Locked data) = data


lock : a -> Protected a
lock = Locked
