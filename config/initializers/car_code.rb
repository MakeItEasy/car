module Car
  module Code
    POST_STATUS = {
      # 草稿
      draft: '00',
      # 等待审核
      waiting: '01',
      # 发布(审核通过)
      published: '02',
      # 审核拒绝
      rejected: '03',
      # 锁定
      locked: '04' 
    }
  end
end
