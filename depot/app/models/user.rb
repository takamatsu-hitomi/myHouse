class User < ApplicationRecord
	after_destroy :ensure_an_admin_remains

	# validate 入力の制限　入力している、かつ、ユニークな値である場合にのみ有効
	validates :name, presence:true, uniqueness: true
	has_secure_password

	private
	def ensure_an_admin_remains
		if User.count.zero?
			# 例外を起こしてロールバックを発生させる。
			raise "最後のユーザは削除できません"
		end
	end
end
