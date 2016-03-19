module SliceShow.Protected (Protected, unlock, lock) where


type Protected a = Protected a


unlock : Protected a -> a
unlock (Protected data) = data


lock : a -> Protected a
lock = Protected
