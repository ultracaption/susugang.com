# encoding=utf-8

tags = [
  { id:  0, image_file_name:  'tag0.png', category: 0, content: '교수님 짱' },
  { id:  1, image_file_name:  'tag1.png', category: 0, content: 'ZZZ'       },
  { id:  2, image_file_name:  'tag2.png', category: 1, content: '교재위주'  },
  { id:  3, image_file_name:  'tag3.png', category: 1, content: '영어강의'  },
  { id:  4, image_file_name:  'tag4.png', category: 1, content: '발표위주'  },
  { id:  5, image_file_name:  'tag5.png', category: 2, content: '백퍼체크'  },
  { id:  6, image_file_name:  'tag6.png', category: 2, content: '랜덤체크'  },
  { id:  7, image_file_name:  'tag7.png', category: 2, content: '대출가능'  },
  { id:  8, image_file_name:  'tag8.png', category: 3, content: 'ALL+'      },
  { id:  9, image_file_name:  'tag9.png', category: 3, content: '암기식'    },
  { id: 10, image_file_name: 'tag10.png', category: 3, content: '논술형'    },
  { id: 11, image_file_name: 'tag11.png', category: 3, content: '몰아봄'    }
]

TAGS = tags.map do |tag|
  Tag.new tag
end
